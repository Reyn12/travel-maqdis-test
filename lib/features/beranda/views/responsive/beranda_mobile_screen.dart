import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_loading_animation.dart';
import 'package:maqdis_connect/features/beranda/controllers/prayer_times_controller.dart';
import 'package:maqdis_connect/features/beranda/widgets/all_features_bottom.dart';
import 'package:maqdis_connect/features/beranda/widgets/prayer_times.dart';
import 'package:maqdis_connect/features/beranda/widgets/time_diff.dart';
import 'package:maqdis_connect/features/doa/views/manasik_screen.dart';
import 'package:maqdis_connect/features/profile/controllers/profile_controller.dart';

class BerandaMobileScreen extends StatelessWidget {
  const BerandaMobileScreen(
      {super.key,
      required this.profileController,
      required this.prayerTimesController});

  final ProfileController profileController;
  final PrayerTimesController prayerTimesController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.8,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_beranda.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Assalamu'alaikum",
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Obx(() {
                              return Text(
                                profileController.profile.value.name,
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Obx(() {
                      return TimeDiff(
                        regionName1: 'Jakarta',
                        regionName2: 'Mekkah',
                        localTime1: prayerTimesController.jakartaTime.value,
                        localTime2: prayerTimesController.mekkahTime.value,
                      );
                    }),
                    const Spacer(),
                    Obx(() {
                      if (prayerTimesController.isPrayerTimesLoading.value) {
                        return const Center(child: WLoadingAnimation());
                      }

                      final prayerTimes =
                          prayerTimesController.prayerTimes.value;
                      if (prayerTimes == null) {
                        return const Center(child: WLoadingAnimation());
                      }
                      return PrayerTimes(
                        subuh: _formatTime(prayerTimes.fajrStartTime),
                        dzuhur: _formatTime(prayerTimes.dhuhrStartTime),
                        ashar: _formatTime(prayerTimes.asrStartTime),
                        maghrib: _formatTime(prayerTimes.maghribStartTime),
                        isya: _formatTime(prayerTimes.ishaStartTime),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          AllFeaturesBottom(
            onTapUmroh: () {
              Get.toNamed('/praktekScreen');
            },
            onTapManasik: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManasikScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return "--:--";
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}
