import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BenefitsSection extends StatelessWidget {
  const BenefitsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF7C3AED);
    final textColor = const Color(0xFF1F2937);
    final secondaryText = const Color(0xFF6B7280);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        children: const [
          BenefitCard(
            icon: Icons.category,
            title: 'Organização por categorias',
            description: 'Separe gastos por tipo e acompanhe de forma simples',
          ),
          BenefitCard(
            icon: Icons.schedule,
            title: 'Controle de parcelas',
            description: 'Gastos parcelados e efetivação futura',
          ),
          BenefitCard(
            icon: Icons.pie_chart,
            title: 'Relatórios Visuais',
            description: 'Gráficos por tipo, mês e categoria',
          ),
          BenefitCard(
            icon: Icons.lock,
            title: 'Privacidade garantida',
            description: 'Login seguro com Supabase',
          ),
        ],
      ),
    );
  }
}

class BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const BenefitCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF7C3AED);
    final textColor = const Color(0xFF1F2937);
    final secondaryText = const Color(0xFF6B7280);

    return SizedBox(
      width: 240,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(icon, size: 48, color: primary),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: secondaryText,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
