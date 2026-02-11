/// Converts E.164 phone number to a stable synthetic email for Appwrite.
/// Appwrite client API has no "phone + password" session; we use email/password
/// APIs with this derived email so the UX remains phone + password.
String phoneToSyntheticEmail(String e164Phone) {
  final digits = e164Phone.replaceAll(RegExp(r'[^\d]'), '');
  return '$digits@phone.avora.local';
}
