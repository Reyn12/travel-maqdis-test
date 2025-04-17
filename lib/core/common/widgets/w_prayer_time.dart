import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WPrayerTime extends StatelessWidget {
  const WPrayerTime(
      {super.key,
      required this.prayerType,
      required this.prayerIcon,
      required this.prayerTime});

  final String prayerType;
  final String prayerIcon;
  final String prayerTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          prayerType,
          style: GoogleFonts.lato(
              fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Image.asset(
          prayerIcon,
          scale: 2,
        ),
        const SizedBox(height: 4),
        Text(
          prayerTime,
          style: GoogleFonts.lato(
              fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ],
    );
  }
}
