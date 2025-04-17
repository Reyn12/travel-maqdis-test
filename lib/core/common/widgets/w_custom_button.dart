import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WCustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double radius;
  final bool trailing;
  final double verticalPadding;
  final double horizontalPadding;
  final bool iconOnly;
  final bool leading;
  final String leadingImg;
  final IconData? icon;
  final double iconSize;
  final Color iconColor;
  final Color buttonColor;
  final BoxBorder? border;
  final double? buttonWidth;
  final List<BoxShadow>? boxShadow;

  const WCustomButton({
    super.key,
    this.onPressed,
    this.buttonColor = const Color(0xff1D8CC6),
    this.buttonText = '',
    this.fontSize = 14,
    this.fontColor = Colors.white,
    this.fontWeight = FontWeight.w700,
    this.iconOnly = false,
    this.leading = false,
    this.leadingImg = 'assets/devicon_google.png',
    this.icon,
    this.iconSize = 16,
    this.iconColor = Colors.white,
    this.trailing = false,
    this.radius = 12,
    this.verticalPadding = 8,
    this.horizontalPadding = 12,
    this.border,
    this.buttonWidth,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ??
          () {
            print('clicked');
          },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: buttonWidth,
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(radius),
            border: border,
            boxShadow: boxShadow),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading
                ? Row(
                    children: [
                      Image.asset(
                        leadingImg,
                        scale: 2.5,
                      ),
                      const SizedBox(width: 10)
                    ],
                  )
                : const SizedBox.shrink(),
            !iconOnly
                ? Text(
                    buttonText,
                    style: GoogleFonts.lato(
                      color: fontColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  )
                : icon != null
                    ? Icon(
                        icon,
                        size: iconSize,
                        color: iconColor,
                      )
                    : const SizedBox.shrink(),
            Visibility(
              visible: trailing,
              child: const Row(
                children: [
                  SizedBox(width: 2),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
