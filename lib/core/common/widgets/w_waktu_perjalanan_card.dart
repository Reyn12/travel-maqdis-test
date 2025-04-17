import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';

class WWaktuPerjalananCard extends StatelessWidget {
  const WWaktuPerjalananCard({super.key, required this.waktuPerjalanan});

  final String waktuPerjalanan;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: GlobalColors.mainColor.withOpacity(0.3),
          )
        ],
        gradient: LinearGradient(
          colors: [
            GlobalColors.mainColor,
            const Color(0xFF43A5D9),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/progress_2nd_layer.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/progress_1st_layer.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              'Waktu Perjalanan',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                waktuPerjalanan,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
