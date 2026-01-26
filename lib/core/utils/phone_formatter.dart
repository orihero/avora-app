import 'package:flutter/services.dart';

/// Custom formatter for Uzbek phone numbers: +998 90 123 45 67
class UzbekPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Remove all non-digit characters
    final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');

    // If empty, return empty
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Format: +998 XX XXX XX XX
    final buffer = StringBuffer('+998 ');
    final digits = digitsOnly.startsWith('998')
        ? digitsOnly.substring(3)
        : digitsOnly;

    for (int i = 0; i < digits.length && i < 9; i++) {
      if (i == 2) {
        buffer.write(' ');
      } else if (i == 5) {
        buffer.write(' ');
      } else if (i == 7) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
