/// Model representing a phone country with its dial code and flag
class PhoneCountry {
  final String code; // ISO country code (e.g., "UZ", "KZ", "RU", "TR")
  final String dialCode; // International dial code (e.g., "+998", "+7", "+90")
  final String name; // Country name
  final String flag; // Flag emoji or asset path

  const PhoneCountry({
    required this.code,
    required this.dialCode,
    required this.name,
    required this.flag,
  });

  /// Get the full phone number in E.164 format
  String getFullNumber(String localNumber) {
    final cleaned = localNumber.replaceAll(RegExp(r'[^\d]'), '');
    return '$dialCode$cleaned';
  }
}

/// Supported phone countries: Central Asian countries, Russia, and Turkey
class PhoneCountries {
  // Central Asian countries
  static const uzbekistan = PhoneCountry(
    code: 'UZ',
    dialCode: '+998',
    name: 'Uzbekistan',
    flag: '🇺🇿',
  );

  static const kazakhstan = PhoneCountry(
    code: 'KZ',
    dialCode: '+7',
    name: 'Kazakhstan',
    flag: '🇰🇿',
  );

  static const kyrgyzstan = PhoneCountry(
    code: 'KG',
    dialCode: '+996',
    name: 'Kyrgyzstan',
    flag: '🇰🇬',
  );

  static const tajikistan = PhoneCountry(
    code: 'TJ',
    dialCode: '+992',
    name: 'Tajikistan',
    flag: '🇹🇯',
  );

  static const turkmenistan = PhoneCountry(
    code: 'TM',
    dialCode: '+993',
    name: 'Turkmenistan',
    flag: '🇹🇲',
  );

  // Russia
  static const russia = PhoneCountry(
    code: 'RU',
    dialCode: '+7',
    name: 'Russia',
    flag: '🇷🇺',
  );

  // Turkey
  static const turkey = PhoneCountry(
    code: 'TR',
    dialCode: '+90',
    name: 'Turkey',
    flag: '🇹🇷',
  );

  /// List of all supported countries
  static const List<PhoneCountry> all = [
    uzbekistan, // Default (first in list)
    kazakhstan,
    kyrgyzstan,
    tajikistan,
    turkmenistan,
    russia,
    turkey,
  ];

  /// Default country (Uzbekistan)
  static const PhoneCountry defaultCountry = uzbekistan;

  /// Find a country by its code
  static PhoneCountry? findByCode(String code) {
    try {
      return all.firstWhere((country) => country.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Find a country by its dial code
  static PhoneCountry? findByDialCode(String dialCode) {
    try {
      return all.firstWhere((country) => country.dialCode == dialCode);
    } catch (e) {
      return null;
    }
  }
}
