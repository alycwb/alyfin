import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onStart;
  const LandingAppBar({Key? key, required this.onStart}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final textColor = const Color(0xFF1F2937);
    final secondaryText = const Color(0xFF6B7280);
    final buttonColor = const Color(0xFF7C3AED);
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      title: Text(
        'Alysoft Finanças',
        style: GoogleFonts.poppins(
            color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      actions: [
        _NavItem(label: 'Início', onTap: () {}, color: secondaryText),
        _NavItem(label: 'Funcionalidades', onTap: () {}, color: secondaryText),
        _NavItem(label: 'Segurança', onTap: () {}, color: secondaryText),
        _NavItem(label: 'Contato', onTap: () {}, color: secondaryText),
        TextButton(
          onPressed: onStart,
          style: TextButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)),
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 12),
          ),
          child: Text(
            'Comece Agora',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _NavItem(
      {Key? key, required this.label, required this.onTap, this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(label, style: GoogleFonts.poppins(color: color)),
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16)),
    );
  }
}
