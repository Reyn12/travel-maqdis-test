import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WUserLengths extends StatelessWidget {
  const WUserLengths({super.key, required this.memberCount});

  final String memberCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const FittedBox(
            fit: BoxFit.fitHeight,
            child: Icon(
              Icons.group,
              size: 18,
              color: Colors.white,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 2),
            child: FittedBox(
              fit: BoxFit.cover,
              child: Text(
                memberCount,
                style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
          )
        ],
      ),
    );
  }
}
