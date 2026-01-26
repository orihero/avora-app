import 'app_localizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  // Login Screen
  @override
  String get loginTitle => 'Login Account';

  @override
  String get loginSubtitle => 'Please login with registered account';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get phoneNumberHint => 'Enter your phone number';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  // Onboarding
  @override
  String get skip => 'Skip';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get onboardingPage1Text =>
      'View and Experience Furniture with the help of Augmented Reality';

  @override
  String get onboardingPage2Text =>
      'Design Your Space\nwith Augmented Reality\nby Creating Room';

  @override
  String get onboardingPage3Text =>
      'Explore World Class\nTop Furnitures as per your\nRequirements & Choice';

  // Home Screen
  @override
  String get findDreamFurniture => 'Find Your\nDream Furniture';

  @override
  String get searchHint => 'Search...';

  @override
  String get categoriesAll => 'All';

  @override
  String get categoriesChair => 'Chair';

  @override
  String get categoriesTable => 'Table';

  @override
  String get categoriesSofa => 'Sofa';

  @override
  String get categoriesLamp => 'Lamp';

  @override
  String get categoriesBed => 'Bed';

  // Common
  @override
  String tappedOn(String item) => 'Tapped on $item';

  @override
  String addedToCart(String item) => 'Added $item to cart';
}
