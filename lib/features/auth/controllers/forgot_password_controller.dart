import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/enums/forgot_password_step.dart';
import 'package:maqdis_connect/features/auth/services/otp_service.dart';

class ForgotPasswordController extends GetxController {
  var currentStep = ForgotPasswordStep.email.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  /// fungsi request otp untuk reset password by email
  Future<void> requestOTP() async {
    isLoading.value = true;

    await OtpService.requestOtp(emailController.text, "reset");

    Future.delayed(const Duration(seconds: 4)).then((_) async {
      Fluttertoast.showToast(msg: "OTP Terkirim");
    });

    isLoading.value = false;
  }

  /// fungsi verify otp untuk reset password by email
  Future<bool> verifyOTP() async {
    isLoading.value = true;

    final response =
        await OtpService.verifyOtp(emailController.text, otpController.text);

    if (response["message"] == "OTP valid") {
      Get.snackbar("Sukses", "OTP berhasil diverifikasi");
      nextStep(); // Pindah ke step New Password
      isLoading.value = false;
      return true;
    } else {
      errorMessage.value = response["message"];
      isLoading.value = false;
      return false;
    }
  }

  /// fungsi reset password by email
  Future<void> resetPassword() async {
    isLoading.value = true;

    final response = await OtpService.resetPassword(
        emailController.text, passwordController.text);

    if (response["message"] == "Password updated successfully") {
      Get.snackbar("Sukses", "Password berhasil diperbarui");
      Get.offAllNamed('/resetPasswordSuccess');
    } else {
      errorMessage.value = response["message"];
    }

    isLoading.value = false;
  }

  void nextStep() {
    if (_validateCurrentStep()) {
      clearErrorMessage(); // Reset error sebelum pindah step

      switch (currentStep.value) {
        case ForgotPasswordStep.email:
          currentStep.value = ForgotPasswordStep.otpCode;
          break;
        case ForgotPasswordStep.otpCode:
          currentStep.value = ForgotPasswordStep.newPassword;
          break;
        case ForgotPasswordStep.newPassword:
          // _register();
          break;
      }
    }
  }

  void previousStep() {
    errorMessage.value = '';

    switch (currentStep.value) {
      case ForgotPasswordStep.otpCode:
        currentStep.value = ForgotPasswordStep.email;
        break;
      case ForgotPasswordStep.newPassword:
        currentStep.value = ForgotPasswordStep.otpCode;
        break;
      default:
        break;
    }
  }

  bool _validateCurrentStep() {
    // Reset error dulu sebelum validasi ulang
    errorMessage.value = '';

    switch (currentStep.value) {
      case ForgotPasswordStep.email:
        if (emailController.text.isEmpty) {
          errorMessage.value = 'Email tidak boleh kosong';
          return false;
        }
        if (!emailController.text.isEmail) {
          errorMessage.value = 'Email tidak valid';
          return false;
        }
        break;
      case ForgotPasswordStep.otpCode:
        if (otpController.text.isEmpty || !otpController.text.isNumericOnly) {
          errorMessage.value = 'OTP tidak valid';
          return false;
        }
        break;
      case ForgotPasswordStep.newPassword:
        if (passwordController.text.isEmpty ||
            passwordController.text.length < 6) {
          errorMessage.value = 'Password minimal 6 karakter';
          return false;
        }
        if (confirmPasswordController.text.isEmpty ||
            confirmPasswordController.text != passwordController.text) {
          errorMessage.value = 'Konfirmasi password tidak sesuai';
          return false;
        }
        break;
    }

    return true;
  }

  void clearErrorMessage() {
    if (errorMessage.value.isNotEmpty) {
      errorMessage.value = '';
      update();
    }
  }

  bool validateForm(GlobalKey<FormState> formKey) {
    // Jalankan validasi form dulu
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Jalankan validasi per step
    bool isValid = _validateCurrentStep();

    // 🛠 Update UI agar validator di-trigger ulang
    update();

    return isValid;
  }
}
