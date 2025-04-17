import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WTextButton extends StatelessWidget {
  const WTextButton({
    super.key,
    this.leadingText = '',
    required this.buttonText,
    required this.onPressed,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.buttonTextColor = const Color(0xff1D8CC6),
  });

  final MainAxisAlignment mainAxisAlignment;
  final String? leadingText;
  final String buttonText;
  final void Function() onPressed;
  final Color buttonTextColor;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$leadingText ',
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB1B1B1),
              ),
            ),
            TextSpan(
              text: buttonText,
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: buttonTextColor,
              ),
              recognizer: TapGestureRecognizer()..onTap = onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
