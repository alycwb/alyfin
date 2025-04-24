import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Disable overscroll glow effect
class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class LandingPage extends StatelessWidget {
  final VoidCallback onStart;
  final Map<String, String> strings;

  const LandingPage({Key? key, required this.strings, required this.onStart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://raw.githubusercontent.com/alycwb/alyfin/main/lib/res/alysoft-finances-logo.png',
                          width: 220,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          strings['landing_header']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1D1D1F),
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: onStart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D1D1F),
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text(
                            strings['start_now']!,
                            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Announcement
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      strings['landing_announcement']!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Seção Como funciona
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          strings['how_it_works_title']!,
                          style: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 32),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: [
                            _Benefit(
                              imageUrl: 'https://img.icons8.com/ios/100/000000/add-user-group-man-man.png',
                              title: strings['benefit1_title']!,
                              description: strings['benefit1_desc']!,
                            ),
                            _Benefit(
                              imageUrl: 'https://img.icons8.com/ios/100/000000/edit-file.png',
                              title: strings['benefit2_title']!,
                              description: strings['benefit2_desc']!,
                            ),
                            _Benefit(
                              imageUrl: 'https://img.icons8.com/ios/100/000000/combo-chart--v1.png',
                              title: strings['benefit3_title']!,
                              description: strings['benefit3_desc']!,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Seção Por que usar
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          strings['why_use_title']!,
                          style: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 32),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: [
                            _Benefit(
                              imageUrl: 'https://img.icons8.com/ios/100/000000/free-shipping.png',
                              title: strings['free_title']!,
                              description: strings['free_desc']!,
                            ),
                            _Benefit(
                              imageUrl: 'https://img.icons8.com/ios/100/000000/checked.png',
                              title: strings['easy_title']!,
                              description: strings['easy_desc']!,
                            ),
                            _Benefit(
                              imageUrl: 'https://img.icons8.com/ios-filled/100/000000/block.png',
                              title: strings['no_ads_title']!,
                              description: strings['no_ads_desc']!,
                            ),
                            _Benefit(
                              imageUrl: 'https://img.icons8.com/ios/100/000000/money.png',
                              title: strings['control_title']!,
                              description: strings['control_desc']!,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Footer
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                    child: Text(
                      strings['footer_text']!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: const Color(0xFF6E6E73)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const _Benefit({Key? key, required this.imageUrl, required this.title, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(imageUrl, width: 64),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFA364F5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF6E6E73)),
          ),
        ],
      ),
    );
  }
}
