# Appwrite configuration (fix login / "not-configured.invalid" error)

If you see a **ClientException** with **Failed host lookup: 'not-configured.invalid'** when logging in, the app is not pointed at a real Appwrite backend. Configure it using your existing **.env** file.

## 1. Create an Appwrite project (if you don’t have one)

- Go to [Appwrite Cloud](https://cloud.appwrite.io) (or use your self-hosted URL).
- Create a project and note:
  - **Project ID** (Project Settings → General).
  - **Endpoint**: for cloud use `https://cloud.appwrite.io/v1`; for self-hosted use `https://your-domain.com/v1`.

## 2. Configure the app with `.env`

The app reads configuration at **build time** from your `.env` file via Flutter’s `--dart-define-from-file`.

1. Copy the example file if you don’t have a `.env` yet:
   ```bash
   cp .env.example .env
   ```
2. Edit **`.env`** and set at least:
   - **`APPWRITE_ENDPOINT`** – e.g. `https://cloud.appwrite.io/v1`
   - **`APPWRITE_PROJECT_ID`** – your project ID from the Appwrite console

Example (login will work with just these two):

```env
APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your-actual-project-id
```

3. **`.env`** is already in `.gitignore`. Don’t commit real project IDs or secrets.

## 3. Run the app with the config

**Option A – VS Code / Cursor**

- Select the run configuration **"avora-app (Appwrite)"** and run (F5 or Run > Start Debugging).  
- It uses `--dart-define-from-file=.env` so your `.env` is applied.

**Option B – Command line**

```bash
flutter run -d <device-id> --dart-define-from-file=.env
```

Example for a specific device:

```bash
flutter run -d AKSC025715000898 --dart-define-from-file=.env
```

After this, login should hit your Appwrite endpoint instead of `not-configured.invalid`.

## 4. Enable Auth in your Appwrite project

- In the Appwrite console, go to **Auth** → **Settings** (or **Auth** → **Providers**).
- Enable the **Email/Password** provider. No API key is required for client-side login/signup; the app uses the project ID and endpoint only.

## 5. Phone-based users (synthetic email)

The app uses **phone number + password** in the UI but talks to Appwrite via **email/password** auth. Phone numbers are converted to a stable synthetic email (e.g. `998901234567@phone.avora.local`) so that:

- Users see a single phone + password flow.
- Appwrite stores one user per phone; you may see these synthetic addresses in the **Users** list in the console.

## 6. "Role: users missing scopes (collections.read)" on the auction page

This error means the **role** assigned to your signed-in user (e.g. "Phone" or "phone number") does not have the **scope** required to read database collections. The app now uses the same session for auction requests as for auth, so the user’s role must be allowed to use the Databases API.

**Fix in Appwrite Console:**

1. **Grant the role the right scope**  
   In your Appwrite project, find where **roles** or **auth providers** are configured (e.g. **Auth** → **Settings**, or **Auth** → **Providers** → **Phone**). Ensure the role that phone-authenticated users get (often "users" or "Phone") has the **collections.read** (or **databases.read**) scope so it can call list documents / get document on your database.

2. **Ensure collection permissions include that role**  
   In **Databases** → your database → each table used by the auction (e.g. `auctions`, `auction_products`, `variables`, `votes`, `participation_requests`, `bids`, `winner_confirmation`), open **Settings** → **Permissions**.  
   - If your tables use `read("users")`, phone users must have the **users** role (default for email/password; synthetic-email phone users usually get this).  
   - If phone users get a different role (e.g. "Phone"), add **Read** permission for that role on each of these tables.

After updating the role’s scope and/or the table permissions, sign in again and open the auction page; the error should stop.
