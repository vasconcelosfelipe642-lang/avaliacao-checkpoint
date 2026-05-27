import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usedev_uninassau/src/screens/initial_screen.dart';
import 'package:usedev_uninassau/src/services/auth_service.dart';

class AlreadyLoggedInDialog extends StatelessWidget {
  const AlreadyLoggedInDialog({super.key});

  static const Color _purple = Color(0xFF780BF7);
  static const Color _exitColor = Color(0xFFE91E63);

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlreadyLoggedInDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final poppins = GoogleFonts.poppins().fontFamily;
    final orbitron = GoogleFonts.orbitron().fontFamily;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Já logado',
        style: TextStyle(
          fontFamily: orbitron,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      content: Text(
        'Você já possui uma sessão ativa. Deseja continuar para a loja ou sair?',
        style: TextStyle(fontFamily: poppins, fontSize: 16),
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () async {
            await AuthService.instance.logout();
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
          child: Text(
            'SAIR',
            style: TextStyle(
              fontFamily: poppins,
              fontWeight: FontWeight.bold,
              color: _exitColor,
            ),
          ),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const InitialScreen()),
              (route) => false,
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: _purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(
            'CONTINUAR',
            style: TextStyle(
              fontFamily: poppins,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
