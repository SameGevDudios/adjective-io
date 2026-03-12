import 'package:flutter/material.dart';

class LinkLabel extends StatelessWidget {
  final String message;
  final VoidCallback onTap;

  const LinkLabel({required this.message, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(message, style: TextStyle(decoration: TextDecoration.underline)),
    );
  }
}
