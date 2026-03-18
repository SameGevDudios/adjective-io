import 'package:flutter/material.dart';

class LinkLabel extends StatelessWidget {
  final String message;
  final VoidCallback onTap;
  final TextStyle? style;

  const LinkLabel({required this.message, required this.onTap, this.style, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(message, style: style ?? const TextStyle(decoration: TextDecoration.underline)),
    );
  }
}
