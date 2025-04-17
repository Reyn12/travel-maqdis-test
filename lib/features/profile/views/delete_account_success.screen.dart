import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_app_bar.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/core/common/widgets/w_success_anim.dart';
import 'package:maqdis_connect/features/auth/views/imports/login_screen.dart';

class DeleteAccountSuccessScreen extends StatelessWidget {
  const DeleteAccountSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WCustomAppBar(
        centerTitle: true,
        title: 'Hapus Akun',
        removeBackButton: true,
      ),
      body: PopScope(
        canPop: false,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const Expanded(
                child: WSuccessAnim(
                  title: 'Selesai!',
                  subtitle: 'Akun anda sudah berhasil dihapus permanen',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: WCustomButton(
                  onPressed: () {
                    Get.offAll(() => const LoginScreen());
                  },
                  verticalPadding: 16,
                  buttonText: 'Tutup',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
