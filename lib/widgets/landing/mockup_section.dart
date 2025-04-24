import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MockupSection extends StatelessWidget {
  const MockupSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Veja o Dashboard em ação',
            style: GoogleFonts.poppins(
              color: const Color(0xFF1F2937),
              fontSize: isWide ? 32 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SvgPicture.asset(
            'assets/finance.svg',
            width: isWide ? 600 : 300,
          ),
        ],
      ),
    );
  }
}
