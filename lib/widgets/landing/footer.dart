import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class LandingFooter extends StatelessWidget {
  final Language lang;
  final ValueChanged<Language> onLocaleChange;
  const LandingFooter({Key? key, required this.lang, required this.onLocaleChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = const Color(0xFF6B7280);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: () {}, child: Text('Sobre', style: GoogleFonts.poppins(color: textColor))),
              const SizedBox(width: 24),
              TextButton(onPressed: () {}, child: Text('Contato', style: GoogleFonts.poppins(color: textColor))),
              const SizedBox(width: 24),
              TextButton(onPressed: () {}, child: Text('Política de Privacidade', style: GoogleFonts.poppins(color: textColor))),
              const SizedBox(width: 24),
              TextButton(onPressed: () {}, child: Text('Termos de Uso', style: GoogleFonts.poppins(color: textColor))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<Language>(
                value: lang,
                items: const [
                  DropdownMenuItem(value: Language.en, child: Text('🇺🇸 English')),
                  DropdownMenuItem(value: Language.pt, child: Text('🇧🇷 Português')),
                ],
                onChanged: (val) {
                  if (val != null) onLocaleChange(val);
                },
              ),
              const SizedBox(width: 32),
              IconButton(icon: Icon(Icons.facebook, color: textColor), onPressed: () {}),
              IconButton(icon: Icon(Icons.twitter, color: textColor), onPressed: () {}),
              IconButton(icon: Icon(Icons.linkedin, color: textColor), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '© 2025 Alysoft Finanças',
            style: GoogleFonts.poppins(color: textColor),
          ),
        ],
      ),
    );
  }
}
