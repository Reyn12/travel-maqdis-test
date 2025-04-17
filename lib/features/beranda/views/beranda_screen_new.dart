import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_enum_loading_anim.dart';
import 'package:maqdis_connect/features/beranda/controllers/prayer_times_controller.dart';
import 'package:maqdis_connect/features/beranda/views/responsive/beranda_desktop_screen.dart';
import 'package:maqdis_connect/features/beranda/views/responsive/beranda_mobile_screen.dart';
import 'package:maqdis_connect/features/profile/controllers/profile_controller.dart';

class BerandaScreenNew extends StatefulWidget {
  const BerandaScreenNew({super.key});

  @override
  State<BerandaScreenNew> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreenNew> {
  final ProfileController _profileController = Get.put(ProfileController());
  final PrayerTimesController _prayerTimesController = Get.put(
    PrayerTimesController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          double width = constraints.maxWidth;
          return width > 1000
              ? BerandaDesktopScreen(
                  prayerTimesController: _prayerTimesController,
                  profileController: _profileController,
                )
              : BerandaMobileScreen(
                  profileController: _profileController,
                  prayerTimesController: _prayerTimesController);
        }),
        Obx(() {
          if (_prayerTimesController.isPrayerTimesLoading.value) {
            return const Center(child: WEnumLoadingAnim());
          }

          return const SizedBox.shrink();
        }),
      ],
    ));
  }
}
