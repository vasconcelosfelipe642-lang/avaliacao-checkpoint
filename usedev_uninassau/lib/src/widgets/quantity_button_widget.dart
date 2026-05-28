import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usedev_uninassau/src/widgets/control_button_widget.dart';

class QuantityButtonWidget extends StatelessWidget {
  const QuantityButtonWidget({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    super.key,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ControlButtonWidget(icon: Icons.remove, onPressed: onDecrement),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '$quantity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
        ),
        ControlButtonWidget(icon: Icons.add, onPressed: onIncrement),
      ],
    );
  }
}
