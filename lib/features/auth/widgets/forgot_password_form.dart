// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/features/auth/controllers/forgot_password_controller.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm(
      {super.key,
      this.title = '',
      this.subtitle = '',
      this.customWidget,
      required this.controller});

  final String title;
  final String subtitle;
  final Widget? customWidget;
  final ForgotPasswordController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 120),
          Center(
            child: Image.asset('assets/logo_maqdis_new.png', height: 48),
          ),
          const SizedBox(height: 80),
          if (title != '' && subtitle != '')
            Center(
              child: Text(
                title,
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 2),
          if (title != '' && subtitle != '')
            Center(
              child: Text(
                subtitle,
                style: GoogleFonts.lato(
                  color: const Color(0xFFB1B1B1),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (title != '' && subtitle != '') const SizedBox(height: 28),
          customWidget ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
