import 'package:flutter/material.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';
import 'app_localizations_en.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizationsRu();
  }

  // Login Screen
  String get loginTitle;
  String get loginSubtitle;
  String get phoneNumberLabel;
  String get phoneNumberHint;
  String get passwordLabel;
  String get passwordHint;
  String get forgotPassword;
  String get signIn;
  String get alreadyHaveAccount;
  String get registerLink;

  // Registration Screen
  String get registerTitle;
  String get registerSubtitle;
  String get nameLabel;
  String get nameHint;
  String get confirmPasswordLabel;
  String get confirmPasswordHint;
  String get signUp;
  String get dontHaveAccount;
  String get signInLink;

  // Onboarding
  String get skip;
  String get getStarted;
  String get next;
  String get onboardingPage1Text;
  String get onboardingPage2Text;
  String get onboardingPage3Text;

  // Home Screen
  String get findDreamFurniture;
  String get searchHint;
  String get categoriesAll;
  String get categoriesChair;
  String get categoriesTable;
  String get categoriesSofa;
  String get categoriesLamp;
  String get categoriesBed;

  // Common
  String tappedOn(String item);
  String addedToCart(String item);
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ru', 'uz', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'uz':
        return AppLocalizationsUz();
      case 'en':
        return AppLocalizationsEn();
      case 'ru':
      default:
        return AppLocalizationsRu();
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
