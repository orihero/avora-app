import 'package:flutter/material.dart';
import 'app_text_field.dart';

/// Password field component with built-in visibility toggle
class AppPasswordField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final bool enabled;

  const AppPasswordField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.enabled = true,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      hintText: widget.hintText,
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: const Color(0xFF757575),
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
