import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/core/common/widgets/w_success_anim.dart';
import 'package:maqdis_connect/features/auth/views/imports/login_screen.dart';

class ResetPasswordSuccessScreen extends StatelessWidget {
  const ResetPasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 160,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset('assets/logo_maqdis_new.png', height: 48),
            ),
          ),
          const Positioned.fill(
            child: Center(
              child: WSuccessAnim(
                title: 'Selesai!',
                subtitle: 'Kata sandi anda berhasil di setel ulang',
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: WCustomButton(
              onPressed: () {
                Get.offAll(() => const LoginScreen());
              },
              verticalPadding: 16,
              buttonText: 'Kembali ke login',
            ),
          ),
        ],
      ),
    );
  }
}
