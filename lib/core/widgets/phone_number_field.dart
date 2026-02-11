import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/phone_countries.dart';
import 'country_picker_bottom_sheet.dart';

/// Phone number input field with country code picker
class PhoneNumberField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged; // Called with full phone number (E.164 format)
  final PhoneCountry initialCountry;
  final ValueChanged<PhoneCountry>? onCountryChanged;
  final ValueChanged<String>? onFullNumberChanged; // Called with full phone number when it changes

  const PhoneNumberField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.initialCountry = PhoneCountries.defaultCountry,
    this.onCountryChanged,
    this.onFullNumberChanged,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late PhoneCountry _selectedCountry;
  late TextEditingController _localController;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
    _localController = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _localController.dispose();
    }
    super.dispose();
  }

  void _onCountryChanged(PhoneCountry country) {
    setState(() {
      _selectedCountry = country;
    });
    widget.onCountryChanged?.call(country);
    final fullNumber = getFullPhoneNumber();
    widget.onFullNumberChanged?.call(fullNumber);
  }

  Future<void> _showCountryPicker() async {
    final selected = await CountryPickerBottomSheet.show(
      context,
      selectedCountry: _selectedCountry,
    );
    if (selected != null) {
      _onCountryChanged(selected);
    }
  }

  String getFullPhoneNumber() {
    return _selectedCountry.getFullNumber(_localController.text);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = const Color(0xFFE0E0E0);
    final errorColor = Colors.red;

    return FormField<String>(
      initialValue: '',
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        // Sync full number when country changes (onChanged handles text changes)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final full = getFullPhoneNumber();
          if (state.value != full) state.didChange(full);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null) ...[
              Text(
                widget.label!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              height: 56,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Country code picker button
                  InkWell(
                    onTap: _showCountryPicker,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      constraints: const BoxConstraints(minWidth: 100),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: state.hasError ? errorColor : borderColor,
                          width: state.hasError ? 2 : 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _selectedCountry.flag,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _selectedCountry.dialCode,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF2D2D2D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                            color: Color(0xFF757575),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Phone number input (no built-in error text so layout stays fixed)
                  Expanded(
                    child: TextField(
                      controller: _localController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        final fullNumber = getFullPhoneNumber();
                        widget.onChanged?.call(fullNumber);
                        widget.onFullNumberChanged?.call(fullNumber);
                        state.didChange(fullNumber);
                      },
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: const TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: state.hasError ? errorColor : borderColor,
                            width: state.hasError ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: state.hasError ? errorColor : borderColor,
                            width: state.hasError ? 2 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF7BB5C9),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (state.hasError) ...[
              const SizedBox(height: 8),
              Text(
                state.errorText!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
