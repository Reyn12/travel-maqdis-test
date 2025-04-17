import 'package:flutter/material.dart';
import 'package:maqdis_connect/core/enums/platform_enum.dart';
import 'package:maqdis_connect/features/praktek/controllers/praktek_controller.dart';
import 'package:maqdis_connect/features/praktek/widgets/praktek_body.dart';

class PraktekDesktopScreen extends StatelessWidget {
  const PraktekDesktopScreen({super.key, required this.praktekController});

  final PraktekController praktekController;

  @override
  Widget build(BuildContext context) {
    return PraktekBody(
      platform: PlatformEnum.desktop,
      onTapGrup: () {
        praktekController.handleGrupCheck();
      },
      // onTapMandiri: () => Get.to(() => RoomPage()),
    );
  }
}
