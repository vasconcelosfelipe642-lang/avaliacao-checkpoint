import 'package:flutter/material.dart';

class ControlButtonWidget extends StatelessWidget {
  const ControlButtonWidget({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF0F0F0),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 20, color: Colors.black87),
        ),
      ),
    );
  }
}
