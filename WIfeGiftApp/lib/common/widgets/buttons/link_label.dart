import 'package:flutter/material.dart';

class LinkLabel extends StatelessWidget {
  final String message;
  final Color? color;
  final VoidCallback onTap;
  final TextDecoration? decoration;
  final FontWeight? fontWeight;

  const LinkLabel({
    required this.message,
    this.color,
    required this.onTap,
    this.decoration,
    this.fontWeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        message,
        style: TextStyle(
          decoration: decoration ?? TextDecoration.underline,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
