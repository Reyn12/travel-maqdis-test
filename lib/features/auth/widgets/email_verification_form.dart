import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/core/common/widgets/w_otp_form.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/auth/views/imports/login_screen.dart';

class EmailVerificationForm extends StatefulWidget {
  EmailVerificationForm(
      {super.key,
      required this.otpController,
      required this.emailAddress,
      this.onPressed,
      this.onPressedResend,
      this.canPop = false});

  final TextEditingController otpController;
  final String emailAddress;
  final formKey = GlobalKey<FormState>();
  final void Function()? onPressedResend;
  final void Function()? onPressed;
  final bool canPop;

  @override
  State<EmailVerificationForm> createState() => _EmailVerificationFormState();
}

class _EmailVerificationFormState extends State<EmailVerificationForm> {
  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: false,
        onPopInvoked: widget.canPop
            ? (didPop) {
                Get.off(() => const LoginScreen());
              }
            : (didPop) {},
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: widget.formKey,
                    child: WOtpForm(
                      otpController: widget.otpController,
                      emailAddress: widget.emailAddress,
                      onPressedResend: widget.onPressedResend,
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: keyboardOpen ? 0.0 : 1.0,
                child: Visibility(
                  visible: !keyboardOpen,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: WCustomButton(
                          onPressed: widget.onPressed,
                          buttonColor: GlobalColors.mainColor,
                          fontColor: Colors.white,
                          verticalPadding: 16,
                          buttonText: 'Verifikasi',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
