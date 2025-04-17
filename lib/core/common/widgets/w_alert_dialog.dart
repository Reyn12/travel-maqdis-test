import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';

class WAlertDialog extends StatelessWidget {
  const WAlertDialog({
    super.key,
    required this.dialogTitle,
    this.onPressedLeft,
    this.onPressedRight,
    required this.buttonTextLeft,
    required this.buttonTextRight,
    this.visible = false,
    this.isReactive = false,
    this.fontColorL = Colors.white,
    this.fontColorR = Colors.white,
    this.colorLeftButton = const Color(0xFFD30509),
    this.colorRightButton = const Color(0xFF25D158),
    this.verticalPaddingL = 12,
    this.horizontalPaddingL = 8,
    this.verticalPaddingR = 12,
    this.horizontalPaddingR = 8,
    this.borderL,
    this.borderR,
  });

  final String dialogTitle;
  final void Function()? onPressedLeft;
  final void Function()? onPressedRight;
  final String buttonTextLeft;
  final String buttonTextRight;
  final bool visible;
  final bool isReactive;
  final Color fontColorL;
  final Color fontColorR;
  final Color colorLeftButton;
  final Color colorRightButton;
  final double verticalPaddingL;
  final double horizontalPaddingL;
  final double verticalPaddingR;
  final double horizontalPaddingR;
  final BoxBorder? borderL;
  final BoxBorder? borderR;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      contentPadding:
          const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      actionsPadding:
          const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/exclamation.png',
              scale: 2.2,
            ),
            const SizedBox(height: 20),
            Text(
              dialogTitle,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WCustomButton(
              buttonWidth: 100,
              fontColor: fontColorL,
              verticalPadding: verticalPaddingL,
              horizontalPadding: horizontalPaddingL,
              onPressed: onPressedLeft ?? () => Navigator.pop(context),
              buttonText: buttonTextLeft,
              buttonColor: colorLeftButton,
              radius: 8,
              border: borderL,
            ),
            if (isReactive)
              Obx(
                () => Visibility(
                  visible: visible,
                  child: WCustomButton(
                    buttonWidth: 100,
                    verticalPadding: verticalPaddingR,
                    horizontalPadding: horizontalPaddingR,
                    onPressed: onPressedRight,
                    buttonText: buttonTextRight,
                    buttonColor: colorRightButton,
                    radius: 8,
                    border: borderR,
                  ),
                ),
              ),
            if (!isReactive)
              WCustomButton(
                buttonWidth: 100,
                fontColor: fontColorR,
                verticalPadding: verticalPaddingR,
                horizontalPadding: horizontalPaddingR,
                onPressed: onPressedRight,
                buttonText: buttonTextRight,
                buttonColor: colorRightButton,
                radius: 8,
                border: borderR,
              ),
          ],
        )
      ],
    );
  }
}
