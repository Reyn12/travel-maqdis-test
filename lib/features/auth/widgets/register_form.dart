import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_text_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    required this.controller,
    super.key,
    this.hintText = '',
    this.labelTitle = '',
    this.labelSubtitle = '',
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.isOtp = false,
    this.customWidget = const SizedBox.shrink(),
  });
  final String hintText;
  final String labelTitle;
  final String labelSubtitle;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final bool isOtp;
  final Widget customWidget;

  @override
  State<RegisterForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<RegisterForm> {
  bool obsecureText = true;

  @override
  Widget build(BuildContext context) {
    if (widget.isOtp) {
      return widget.customWidget;
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelTitle,
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.labelSubtitle,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFB1B1B1),
            ),
          ),
          const SizedBox(height: 20),
          WTextField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              hintText: widget.hintText,
              obscureText: widget.obscureText,
              suffixIcon: widget.suffixIcon),
        ],
      );
    }
  }
}
