import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/core/common/widgets/w_text_button.dart';
import 'package:maqdis_connect/features/auth/controllers/login_controller.dart';
import 'package:maqdis_connect/features/auth/views/imports/login_screen.dart';
import 'package:maqdis_connect/features/auth/views/imports/register_screen.dart';
import 'package:lottie/lottie.dart';

class RegisterLandingScreen extends StatefulWidget {
  const RegisterLandingScreen({super.key});

  @override
  State<RegisterLandingScreen> createState() => _RegisterLandingScreenState();
}

class _RegisterLandingScreenState extends State<RegisterLandingScreen> {
  final loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Get.offAll(() => const LoginScreen());
        },
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/daftar_background.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 160,
              left: 0,
              right: 0,
              child: Center(
                child: Lottie.asset(
                  'assets/daftar_anim.json',
                  height: 200,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Text(
                          'Mulai Sekarang',
                          style: GoogleFonts.lato(
                              fontSize: 28, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Please enter your details',
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFB1B1B1)),
                        ),
                        const SizedBox(height: 25),
                        WCustomButton(
                          onPressed: () {
                            loginController.signInWithGoogle();
                          },
                          leading: true,
                          border: Border.all(
                              color: const Color(0xFFE9E9E9), width: 1.5),
                          buttonColor: Colors.white,
                          verticalPadding: 14,
                          fontColor: Colors.black,
                          fontSize: 16,
                          radius: 14,
                          buttonText: 'Daftar dengan Google',
                        ),
                        const SizedBox(height: 10),
                        WCustomButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen())),
                          verticalPadding: 14,
                          fontSize: 16,
                          radius: 14,
                          buttonText: 'Daftar dengan email',
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  WTextButton(
                    leadingText: 'Sudah memiliki akun?',
                    buttonText: 'Masuk di sini',
                    onPressed: () {
                      Get.offAll(
                        () => const LoginScreen(),
                        transition: Transition.fadeIn,
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
