// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_dialog.dart';
import 'package:maqdis_connect/features/auth/services/auth_service.dart';
import 'package:maqdis_connect/features/auth/services/google_auth_service.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/auth/services/otp_service.dart';
import 'package:maqdis_connect/features/auth/views/register_success.screen.dart';
import 'package:maqdis_connect/features/auth/widgets/email_verification_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/common/navbar/home.dart';

class LoginController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email',
    ],
    clientId: dotenv.env['GOOGLE_CLIENT_ID'], // maqdis google client web gcc
  );
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  final AuthService _apiService = AuthService();
  RxBool isLoading = false.obs;
  RxBool loginStatus = false.obs;
  RxBool isAttemptedLogin = false.obs;
  RxString errorMessage = ''.obs;
  RxString emailSaved = ''.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // login logic (email & password)
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    isAttemptedLogin.value = true;

    try {
      final userLogin = await _apiService.connectApi(email, password);

      if (userLogin != null && userLogin.status == 'success') {
        await SharedPreferencesService.simpanToken(userLogin.token);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('loginType', 'api');
        await SharedPreferencesService.saveLoginType('api');
        print(prefs.getString('loginType'));

        loginStatus.value = true;
        await Fluttertoast.showToast(msg: 'Berhasil Masuk');
        await Get.offAll<dynamic>(() => Home());
      } else {
        loginStatus.value = false;
        await Fluttertoast.showToast(msg: 'Email atau Kata sandi salah!');
      }
    } catch (e) {
      print('Login Error: $e');

      // Ambil pesan error tanpa 'Exception: '
      final errorMessage = e.toString().replaceAll('Exception: ', '');

      if (errorMessage.contains('Akun belum diverifikasi')) {
        emailSaved.value = email;
        print('email verifikasi : ${emailSaved.value}');
        // Tampilkan Dialog Jika Akun Belum Diverifikasi
        WCustomDialog.show(
          "Verifikasi Diperlukan",
          errorMessage,
          'Verifikasi Email',
          onConfirm: () async {
            Get.back();
            Get.to(() => EmailVerificationForm(
                  canPop: true,
                  otpController: otpController,
                  emailAddress: emailSaved.value,
                  onPressedResend: () async => await requestOTP(),
                  onPressed: () async => await verifyOTP(),
                ));
            await requestOTP();
          },
        );
      } else {
        // Jika error lain, tetap tampilkan toast
        await Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // logic request otp untuk email, jika saat registrasi belum sempat verifikasi
  Future<void> requestOTP() async {
    isLoading.value = true;
    print('email otp : ${emailController.text}');

    await OtpService.requestOtp(emailSaved.value, "register");

    Future.delayed(const Duration(seconds: 4)).then((_) async {
      Fluttertoast.showToast(
          msg:
              "OTP Terkirim"); // Jika email sesuai atau tidak sesuai, toast akan tetpa ditamilkan
    });

    isLoading.value = false;
  }

  // logic verifikasi otp untuk email jika saat registrasi belum sempat verifikasi
  Future<bool> verifyOTP() async {
    isLoading.value = true;

    final response =
        await OtpService.verifyOtp(emailSaved.value, otpController.text);

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

  // logic login with google Oauth2 google cloud console
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final googleUser = await _googleSignIn.signIn();

      print('ini googleUser: $googleUser');

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Kirim token ke backend
        final userLogin =
            await _googleAuthService.loginWithGoogle(googleAuth.idToken!);

        print('ini userLogin: ${googleAuth.idToken}');

        if (userLogin != null) {
          await SharedPreferencesService.simpanToken(userLogin.token);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('loginType', 'google');
          await SharedPreferencesService.saveLoginType('google');

          await Get.offAll(() => Home());
          await Fluttertoast.showToast(msg: 'Berhasil Masuk dengan Google');
        } else {
          await Fluttertoast.showToast(msg: 'Proses login gagal');
        }
      } else {
        await Fluttertoast.showToast(msg: 'Proses login gagal');
      }
    } catch (e) {
      print("Error Google Sign-In: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
