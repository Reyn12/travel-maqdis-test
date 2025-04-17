import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WLocalTime extends StatelessWidget {
  const WLocalTime(
      {super.key, required this.regionName, required this.localTime});

  final String regionName;
  final String localTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          regionName,
          style: GoogleFonts.lato(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        Text(
          localTime,
          style: GoogleFonts.lato(
              fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ],
    );
  }
}
