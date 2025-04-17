import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_animated_fade.dart';
import 'package:maqdis_connect/core/common/widgets/w_loading_animation.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/splash_screen/controllers/user_checking_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final userCheckingController = Get.find<UserCheckingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.19, -1.0),
                end: Alignment(0.19, 1.0),
                colors: [
                  Color(0xFF1D8CC6),
                  Color(0xFF43A5D9),
                  Color(0xFF1D8CC6),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 60,
            child: Transform.translate(
              offset: const Offset(-10, 0),
              child: Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 2,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/comp_top.png'),
                      fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/mosque_silhouette.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Obx(() => userCheckingController.showLogo.value
              ? Center(
                  child: WAnimatedFade(
                    child: Image.asset(
                      'assets/logo.png',
                      height: 40,
                    ),
                  ),
                )
              : const SizedBox()),
          Obx(() => userCheckingController.isLoading.value
              ? const Positioned(
                  bottom: 250,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: WAnimatedFade(child: WLoadingAnimation()),
                  ),
                )
              : const SizedBox()),
        ],
      ),
    );
  }
}
