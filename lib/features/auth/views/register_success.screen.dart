import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/core/common/widgets/w_success_anim.dart';
import 'package:maqdis_connect/features/auth/views/imports/login_screen.dart';

class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen(
      {super.key,
      this.subtitle = 'Anda telah berhasil membuat akun Anda',
      this.buttonText = 'Mulai Sekarang',
      this.onPressed});

  final String subtitle;
  final String buttonText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: WSuccessAnim(
                title: 'Yeaaaayyy!!!',
                subtitle: subtitle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: WCustomButton(
                onPressed:
                    onPressed ?? () => Get.offAll(() => const LoginScreen()),
                verticalPadding: 16,
                buttonText: buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
