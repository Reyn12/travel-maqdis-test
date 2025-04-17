import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WButtonExit extends StatelessWidget {
  const WButtonExit({super.key, required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xffD30509),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 2),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Text(
              'Keluar',
              style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }
}
