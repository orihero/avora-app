import 'app_localizations.dart';

class AppLocalizationsUz extends AppLocalizations {
  // Login Screen
  @override
  String get loginTitle => 'Hisobga kirish';

  @override
  String get loginSubtitle => 'Iltimos, ro\'yxatdan o\'tgan hisob bilan kiring';

  @override
  String get phoneNumberLabel => 'Telefon raqami';

  @override
  String get phoneNumberHint => 'Telefon raqamingizni kiriting';

  @override
  String get passwordLabel => 'Parol';

  @override
  String get passwordHint => 'Parolingizni kiriting';

  @override
  String get forgotPassword => 'Parolni unutdingizmi?';

  @override
  String get signIn => 'Kirish';

  // Onboarding
  @override
  String get skip => 'O\'tkazib yuborish';

  @override
  String get getStarted => 'Boshlash';

  @override
  String get next => 'Keyingi';

  @override
  String get onboardingPage1Text =>
      'Kengaytirilgan realitet yordamida mebelni ko\'ring va bilib oling';

  @override
  String get onboardingPage2Text =>
      'Xonani yaratish orqali\nkengaytirilgan realitet bilan\no\'z makoningizni loyihalashtiring';

  @override
  String get onboardingPage3Text =>
      'Talablaringiz va tanlovingizga mos\ndunyoning eng yaxshi mebellarini\ntadqiq qiling';

  // Home Screen
  @override
  String get findDreamFurniture => 'Orzuingizdagi\nmebelni toping';

  @override
  String get searchHint => 'Qidirish...';

  @override
  String get categoriesAll => 'Barchasi';

  @override
  String get categoriesChair => 'Stul';

  @override
  String get categoriesTable => 'Stol';

  @override
  String get categoriesSofa => 'Divan';

  @override
  String get categoriesLamp => 'Lampa';

  @override
  String get categoriesBed => 'Karavot';

  // Common
  @override
  String tappedOn(String item) => '$item bosildi';

  @override
  String addedToCart(String item) => '$item savatga qo\'shildi';
}
