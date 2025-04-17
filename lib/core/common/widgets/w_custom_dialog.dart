import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';

class WCustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final void Function()? onPressed;
  final String buttonText;
  final Color fontColor;
  final Color colorButton;
  final double verticalPadding;
  final double horizontalPadding;
  final BoxBorder? border;

  const WCustomDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.onPressed,
    required this.buttonText,
    this.fontColor = Colors.white,
    this.colorButton = const Color(0xff1D8CC6),
    this.border,
    this.verticalPadding = 12,
    this.horizontalPadding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.bottomCenter,
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
      content: Text(message),
      actions: [
        Row(
          children: [
            Expanded(
              child: WCustomButton(
                buttonWidth: 100,
                fontColor: fontColor,
                verticalPadding: verticalPadding,
                horizontalPadding: horizontalPadding,
                onPressed: onConfirm ?? () => Navigator.pop(context),
                buttonText: buttonText,
                buttonColor: colorButton,
                radius: 8,
                border: border,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Fungsi static untuk menampilkan dialog dengan GetX
  static void show(String title, String message, String buttonText,
      {required void Function() onConfirm}) {
    Get.dialog(
      WCustomDialog(
        title: title,
        message: message,
        onConfirm: onConfirm,
        buttonText: buttonText, // Tutup dialog saat tombol OK ditekan
      ),
    );
  }
}
