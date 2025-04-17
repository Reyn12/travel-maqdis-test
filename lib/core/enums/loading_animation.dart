import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';

enum LoadingAnimation {
  plane,
  delete,
  stretchedDots;

  Widget getWidget({Color? color, double? size}) {
    switch (this) {
      case LoadingAnimation.plane:
        return Lottie.asset('assets/plane_loader_anim.json',
            width: size, height: size);
      case LoadingAnimation.delete:
        return Lottie.asset('assets/delete_anim.json',
            width: size, height: size);
      case LoadingAnimation.stretchedDots:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LoadingAnimationWidget.stretchedDots(
                color: GlobalColors.mainColor, size: 20),
            const SizedBox(height: 5),
            Material(
              elevation: 0,
              color: Colors.white,
              child: Text(
                'Mempersiapkan ruangan',
                style: GoogleFonts.lato(fontSize: 12),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            )
          ],
        );
    }
  }
}
