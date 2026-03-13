import 'package:flutter/material.dart';

class CustomOutlinedFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? label;
  final IconData? icon;
  final Color color;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomOutlinedFormField({
    this.controller,
    this.keyboardType,
    this.label,
    this.icon,
    required this.color,
    this.obscureText = false,
    this.validator,
    super.key,
  });

  InputBorder get _inputBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(100),
    borderSide: BorderSide(color: color, width: 2),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon!, color: color) : null,
        enabledBorder: _inputBorder,
        focusedBorder: _inputBorder,
        errorBorder: _inputBorder,
        focusedErrorBorder: _inputBorder,
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
