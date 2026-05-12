import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BrandTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final Widget? prefix;
  final String? Function(String?)? validator;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final List<String>? autofillHints;

  const BrandTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.prefix,
    this.validator,
    this.maxLines,
    this.inputFormatters,
    this.focusNode,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : (maxLines ?? 1),
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffix,
        prefix: prefix,
      ),
      validator: validator,
    );
  }
}
