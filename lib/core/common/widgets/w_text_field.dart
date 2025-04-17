import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_text_button.dart';

class WTextField extends StatelessWidget {
  const WTextField({
    super.key,
    this.enabled = true,
    this.label = '',
    this.labelColor = Colors.black,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.filled = true,
    this.overrideValidator = false,
    this.onPressed,
    this.buttonText = '',
    this.textButton = false,
    this.maxLines = 1,
    this.verticalPadding = 0,
    this.horizonalPadding = 20,
    this.onChanged,
  });

  final String? Function(String?)? validator;
  final bool overrideValidator;
  final void Function(String)? onChanged;
  final bool enabled;
  final String label;
  final Color labelColor;
  final TextEditingController controller;
  final bool filled;
  final bool obscureText;
  final String hintText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Function()? onPressed;
  final String buttonText;
  final bool textButton;
  final int maxLines;
  final double verticalPadding;
  final double horizonalPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: label != '',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.lato(
                      color: labelColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Visibility(
                    visible: textButton,
                    child: WTextButton(
                        buttonText: buttonText, onPressed: onPressed ?? () {}),
                  )
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          cursorColor: const Color(0xff1D8CC6),
          cursorWidth: 1.5,
          maxLines: maxLines,
          onChanged: onChanged,
          validator: overrideValidator
              ? validator
              : (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lahan ini tidak boleh kosong';
                  }
                  return validator?.call(value);
                },
          style: GoogleFonts.lato(
            color: enabled ? Colors.black : const Color(0xFFB1B1B1),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
          },
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE9E9E9)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE9E9E9)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xff1D8CC6)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE9E9E9)),
            ),
            filled: filled,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
                horizontal: horizonalPadding, vertical: verticalPadding),
            hintText: hintText,
            hintStyle: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFB1B1B1),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
