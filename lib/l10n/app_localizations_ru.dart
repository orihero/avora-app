import 'app_localizations.dart';

class AppLocalizationsRu extends AppLocalizations {
  // Login Screen
  @override
  String get loginTitle => 'Войти в аккаунт';

  @override
  String get loginSubtitle => 'Пожалуйста, войдите с зарегистрированным аккаунтом';

  @override
  String get phoneNumberLabel => 'Номер телефона';

  @override
  String get phoneNumberHint => 'Введите номер телефона';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get passwordHint => 'Введите пароль';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get signIn => 'Войти';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get registerLink => 'Регистрация';

  // Registration Screen
  @override
  String get registerTitle => 'Создать аккаунт';

  @override
  String get registerSubtitle => 'Заполните данные для начала';

  @override
  String get nameLabel => 'Полное имя';

  @override
  String get nameHint => 'Введите ваше полное имя';

  @override
  String get confirmPasswordLabel => 'Подтвердите пароль';

  @override
  String get confirmPasswordHint => 'Повторите пароль';

  @override
  String get signUp => 'Зарегистрироваться';

  @override
  String get dontHaveAccount => 'Нет аккаунта?';

  @override
  String get signInLink => 'Войти';

  // Onboarding
  @override
  String get skip => 'Пропустить';

  @override
  String get getStarted => 'Начать';

  @override
  String get next => 'Далее';

  @override
  String get onboardingPage1Text =>
      'Просматривайте и испытывайте мебель с помощью дополненной реальности';

  @override
  String get onboardingPage2Text =>
      'Создайте свой интерьер\nс дополненной реальностью\nпутем создания комнаты';

  @override
  String get onboardingPage3Text =>
      'Исследуйте мебель мирового класса\nв соответствии с вашими\nтребованиями и выбором';

  // Home Screen
  @override
  String get findDreamFurniture => 'Найдите свою\nмечту мебели';

  @override
  String get searchHint => 'Поиск...';

  @override
  String get categoriesAll => 'Все';

  @override
  String get categoriesChair => 'Стул';

  @override
  String get categoriesTable => 'Стол';

  @override
  String get categoriesSofa => 'Диван';

  @override
  String get categoriesLamp => 'Лампа';

  @override
  String get categoriesBed => 'Кровать';

  // Common
  @override
  String tappedOn(String item) => 'Нажато на $item';

  @override
  String addedToCart(String item) => '$item добавлено в корзину';
}
