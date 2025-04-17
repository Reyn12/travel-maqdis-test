import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/core/common/widgets/w_otp_form.dart';
import 'package:maqdis_connect/core/common/widgets/w_text_field.dart';
import 'package:maqdis_connect/core/enums/forgot_password_step.dart';
import 'package:maqdis_connect/features/auth/controllers/forgot_password_controller.dart';
import 'package:maqdis_connect/features/auth/views/imports/login_screen.dart';
import 'package:maqdis_connect/features/auth/widgets/forgot_password_form.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ForgotPasswordController _controller =
      Get.put(ForgotPasswordController());
  bool obscureText = true;
  bool obscureTextConfirm = true;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (_controller.currentStep.value != ForgotPasswordStep.email) {
            _controller.previousStep();
          } else {
            Get.offAll(() => const LoginScreen());
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(() {
                      switch (_controller.currentStep.value) {
                        case ForgotPasswordStep.email:
                          return ForgotPasswordForm(
                            controller: _controller,
                            title: 'Lupa kata sandi?',
                            subtitle:
                                'Jangan khawatir, kami akan mengirimkan petunjuk untuk reset kata sandi',
                            customWidget: Form(
                              key: formKey,
                              child: WTextField(
                                label: 'Email',
                                controller: _controller.emailController,
                                keyboardType: TextInputType.emailAddress,
                                overrideValidator: true,
                                validator: (value) {
                                  return _controller
                                          .errorMessage.value.isNotEmpty
                                      ? _controller.errorMessage.value
                                      : null;
                                },
                                onChanged: (value) =>
                                    _controller.clearErrorMessage(),
                                hintText: 'Masukkan alamat email kamu',
                              ),
                            ),
                          );
                        case ForgotPasswordStep.otpCode:
                          return ForgotPasswordForm(
                            controller: _controller,
                            customWidget: Form(
                              key: formKey,
                              child: WOtpForm(
                                otpController: _controller.otpController,
                                emailAddress: _controller.emailController.text,
                                overrideValidator: true,
                                validator: (value) {
                                  return _controller
                                          .errorMessage.value.isNotEmpty
                                      ? _controller.errorMessage.value
                                      : null;
                                },
                                onPressedResend: () async =>
                                    await _controller.requestOTP(),
                                onChanged: (value) =>
                                    _controller.clearErrorMessage(),
                              ),
                            ),
                          );

                        case ForgotPasswordStep.newPassword:
                          return ForgotPasswordForm(
                            controller: _controller,
                            title: 'Tetapkan kata sandi baru',
                            subtitle:
                                'Pastikan kata sandi mengandung huruf besar, kecil, dan juga angka',
                            customWidget: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WTextField(
                                    label: 'Kata Sandi',
                                    controller: _controller.passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    overrideValidator: true,
                                    validator: (value) {
                                      return _controller
                                              .errorMessage.value.isNotEmpty
                                          ? _controller.errorMessage.value
                                          : null;
                                    },
                                    obscureText: obscureText,
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(
                                        () => obscureText = !obscureText,
                                      ),
                                      icon: Icon(
                                        obscureText
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: const Color.fromRGBO(0, 0, 0, 1),
                                      ),
                                    ),
                                    onChanged: (value) =>
                                        _controller.clearErrorMessage(),
                                    hintText: 'Masukan kata sandi kamu',
                                  ),
                                  const SizedBox(height: 20),
                                  WTextField(
                                    label: 'Konfirmasi Kata Sandi',
                                    controller:
                                        _controller.confirmPasswordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    overrideValidator: true,
                                    validator: (value) {
                                      return _controller
                                              .errorMessage.value.isNotEmpty
                                          ? _controller.errorMessage.value
                                          : null;
                                    },
                                    obscureText: obscureTextConfirm,
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(
                                        () => obscureTextConfirm =
                                            !obscureTextConfirm,
                                      ),
                                      icon: Icon(
                                        obscureText
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: const Color.fromRGBO(0, 0, 0, 1),
                                      ),
                                    ),
                                    onChanged: (value) =>
                                        _controller.clearErrorMessage(),
                                    hintText: 'Masukan kata sandi kamu',
                                  ),
                                ],
                              ),
                            ),
                          );
                      }
                    }),
                  ],
                ),
              )),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: keyboardOpen ? 0.0 : 1.0,
                child: Visibility(
                  visible: !keyboardOpen,
                  child: Column(
                    children: [
                      Obx(() {
                        return WCustomButton(
                          onPressed: () async {
                            print(
                                "Tombol ditekan - Step: ${_controller.currentStep.value}");

                            // Validasi form sebelum melanjutkan ke langkah berikutnya
                            if (_controller.validateForm(formKey)) {
                              if (_controller.currentStep.value ==
                                  ForgotPasswordStep.email) {
                                // Pindah ke langkah berikutnya dan kirim permintaan OTP
                                _controller.nextStep();
                                await _controller.requestOTP();
                              } else if (_controller.currentStep.value ==
                                  ForgotPasswordStep.otpCode) {
                                // Verifikasi OTP, lanjut jika berhasil
                                bool isVerified = await _controller.verifyOTP();
                                if (!isVerified) return;
                              } else if (_controller.currentStep.value ==
                                  ForgotPasswordStep.newPassword) {
                                // Reset kata sandi dan keluar dari fungsi
                                await _controller.resetPassword();
                                return;
                              }
                            } else {
                              print(
                                  "Validasi gagal, tetap di halaman sekarang");
                            }
                          },
                          verticalPadding: 16,
                          buttonText: _controller.currentStep.value ==
                                  ForgotPasswordStep.newPassword
                              ? 'Setel ulang kata sandi'
                              : 'Lanjut',
                        );
                      }),
                      const SizedBox(height: 10),
                      WCustomButton(
                        onPressed: () {
                          if (_controller.currentStep.value !=
                              ForgotPasswordStep.email) {
                            // Kembali ke langkah sebelumnya jika bukan di langkah pertama
                            _controller.previousStep();
                          } else {
                            // Kembali ke halaman login jika di langkah pertama
                            Get.offAll(() => const LoginScreen());
                          }
                        },
                        buttonColor: Colors.transparent,
                        fontColor: const Color(0xFFB1B1B1),
                        verticalPadding: 16,
                        buttonText: 'Kembali',
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
