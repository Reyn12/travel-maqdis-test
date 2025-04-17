import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_text_button.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:pinput/pinput.dart';

class WOtpForm extends StatefulWidget {
  const WOtpForm({
    super.key,
    required this.otpController,
    required this.emailAddress,
    this.onPressedResend,
    this.validator,
    this.overrideValidator = false,
    this.onChanged,
  });

  final TextEditingController otpController;
  final String emailAddress;
  final void Function()? onPressedResend;
  final String? Function(String?)? validator;
  final bool overrideValidator;
  final void Function(String)? onChanged;

  @override
  _WOtpFormState createState() => _WOtpFormState();
}

class _WOtpFormState extends State<WOtpForm> {
  int _timerCountdown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _timerCountdown = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerCountdown > 0) {
        setState(() {
          _timerCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Masukkan kode OTP',
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFB1B1B1),
              ),
              children: [
                const TextSpan(
                  text: 'Kami telah mengirimkan kode ke ',
                ),
                TextSpan(
                  text: widget.emailAddress,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Pinput(
            controller: widget.otpController,
            validator: widget.overrideValidator
                ? widget.validator
                : (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return widget.validator?.call(value);
                  },
            onChanged: widget.onChanged,
            defaultPinTheme: PinTheme(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 60,
                minHeight: 60,
              ),
              width: MediaQuery.of(context).size.width / 6,
              height: MediaQuery.of(context).size.width / 6,
              textStyle: GoogleFonts.lato(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            pinContentAlignment: Alignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          const SizedBox(height: 30),
          WTextButton(
            leadingText: 'Tidak menerima email?',
            buttonText: _timerCountdown > 0
                ? 'Kirim ulang ($_timerCountdown)'
                : 'Kirim ulang',
            buttonTextColor: _timerCountdown > 0
                ? const Color(0xFFB1B1B1)
                : GlobalColors.mainColor,
            onPressed: _timerCountdown > 0
                ? () {}
                : () {
                    debugPrint('Resend OTP clicked!');
                    Future.microtask(() => widget.onPressedResend?.call());
                    _startTimer();
                  },
          ),
        ],
      ),
    );
  }
}
