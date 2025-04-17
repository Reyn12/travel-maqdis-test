import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/enums/register_step.dart';
import 'package:maqdis_connect/features/auth/services/auth_service.dart';
import 'package:maqdis_connect/features/auth/services/otp_service.dart';
import 'package:maqdis_connect/features/auth/views/register_success.screen.dart';
import 'package:maqdis_connect/features/auth/widgets/email_verification_form.dart';

class RegisterController extends GetxController {
  final AuthService _apiService = AuthService();

  var currentStep = RegisterStep.name.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxString email = ''.obs;

  // logic request otp untuk email saat registrasi
  Future<void> requestOTP() async {
    isLoading.value = true;
    print('email otp : ${email.value}');

    await OtpService.requestOtp(email.value, "register");

    Future.delayed(const Duration(seconds: 4)).then((_) async {
      Fluttertoast.showToast(msg: "OTP Terkirim");
    });

    isLoading.value = false;
  }

  // logic verifikasi otp untuk email saat registrasi
  Future<bool> verifyOTP() async {
    isLoading.value = true;

    final response =
        await OtpService.verifyOtp(email.value, otpController.text);

    if (response["message"] == "OTP valid") {
      Get.snackbar("Sukses", "OTP berhasil diverifikasi");
      Get.offAll(
        () => const RegisterSuccessScreen(
          subtitle: 'Email anda telah berhasil diverifikasi.',
        ),
      );
      isLoading.value = false;
      return true;
    } else {
      errorMessage.value = response["message"];
      isLoading.value = false;
      return false;
    }
  }

  void clearErrorMessage() {
    if (errorMessage.value.isNotEmpty) {
      errorMessage.value = '';
      update();
    }
  }

  void nextStep() {
    if (_validateCurrentStep()) {
      switch (currentStep.value) {
        case RegisterStep.name:
          currentStep.value = RegisterStep.email;
          break;
        case RegisterStep.email:
          currentStep.value = RegisterStep.whatsapp;
          email.value = emailController.text;
          break;
        case RegisterStep.whatsapp:
          currentStep.value = RegisterStep.password;
          break;
        case RegisterStep.password:
          currentStep.value = RegisterStep.confirmPassword;
          break;
        case RegisterStep.confirmPassword:
          _register();
          break;
      }
    }
  }

  void resetStep() {
    currentStep.value = RegisterStep.name;
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    whatsappController.clear();
    otpController.clear();
  }

  void previousStep() {
    errorMessage.value = '';

    switch (currentStep.value) {
      case RegisterStep.email:
        currentStep.value = RegisterStep.name;
        break;
      case RegisterStep.whatsapp:
        currentStep.value = RegisterStep.email;
        break;
      case RegisterStep.password:
        currentStep.value = RegisterStep.whatsapp;
        break;
      case RegisterStep.confirmPassword:
        currentStep.value = RegisterStep.password;
        break;
      default:
        break;
    }
  }

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case RegisterStep.name:
        if (nameController.text.isEmpty) {
          errorMessage.value = 'Nama tidak boleh kosong';
          return false;
        }
        break;
      case RegisterStep.email:
        if (emailController.text.isEmpty || !emailController.text.isEmail) {
          errorMessage.value = 'Email tidak valid';
          return false;
        }
        break;
      case RegisterStep.whatsapp:
        if (whatsappController.text.isEmpty) {
          errorMessage.value = 'Nomor WhatsApp tidak boleh kosong';
          return false;
        }
        break;
      case RegisterStep.password:
        if (passwordController.text.isEmpty ||
            passwordController.text.length < 6) {
          errorMessage.value = 'Password minimal 6 karakter';
          return false;
        }
        break;
      case RegisterStep.confirmPassword:
        if (confirmPasswordController.text.isEmpty ||
            confirmPasswordController.text != passwordController.text) {
          errorMessage.value = 'Konfirmasi password tidak sesuai';
          return false;
        }
        break;
    }
    errorMessage.value = '';
    return true;
  }

  Future<void> _register() async {
    isLoading.value = true;

    final result = await _apiService.registerUser(
      nameController.text,
      emailController.text,
      passwordController.text,
      whatsappController.text,
    );

    if (result != null && result['error'] == null) {
      isLoading.value = false;
      Get.snackbar('Success', 'Registrasi berhasil!');
      nextStep();
      resetStep();
      Get.off(() => RegisterSuccessScreen(
          buttonText: 'Verifikasi email anda',
          onPressed: () async {
            Get.off(() => EmailVerificationForm(
                  otpController: otpController,
                  emailAddress: email.value,
                  onPressedResend: () async => await requestOTP(),
                  onPressed: () async => await verifyOTP(),
                ));
            await requestOTP();
          }));
    } else {
      errorMessage.value = result?['error'] as String;
      isLoading.value = false;
      Get.snackbar('Error', errorMessage.value);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    whatsappController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
