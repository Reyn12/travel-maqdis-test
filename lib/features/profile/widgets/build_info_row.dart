import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildInfoRow extends StatelessWidget {
  const BuildInfoRow({
    super.key,
    required this.leadingImg,
    required this.label,
    this.value = '',
    this.labelColor = Colors.black,
  });

  final String leadingImg;
  final String label;
  final String value;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          leadingImg,
          scale: 2,
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: labelColor,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color.fromARGB(255, 129, 129, 129),
            ),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
