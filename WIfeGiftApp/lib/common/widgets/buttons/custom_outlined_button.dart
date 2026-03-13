import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String? label;
  final Color color;
  final double width;
  final VoidCallback? onTap;

  const CustomOutlinedButton({
    this.label,
    required this.color,
    required this.width,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: width, color: color),
      ),
      child: label != null ? Text(label!) : null,
    );
  }
}
