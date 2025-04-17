import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/core/common/widgets/w_waktu_perjalanan_card.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/core/utils/time_formatter.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/player/controllers/audio_room_controller.dart';
import 'package:maqdis_connect/features/player/controllers/player_controller.dart';
import 'package:maqdis_connect/features/player/widgets/dialog_end_room.dart';
import 'package:maqdis_connect/features/room/controllers/progress_doa_controller.dart';

class ProgressPerjalananWidget extends StatelessWidget {
  const ProgressPerjalananWidget(
      {super.key, required this.audioRoomController});

  final AudioRoomController audioRoomController;

  @override
  Widget build(BuildContext context) {
    final progressDoaController = Get.find<ProgressDoaController>();
    final playerController = Get.find<PlayerControllerTesting>();

    return FutureBuilder<void>(
      future: progressDoaController
          .fetchDoaStatus(), // Ganti method dengan fetchDoaStatus
      builder: (context, snapshot) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Obx(() => WWaktuPerjalananCard(
                  waktuPerjalanan: audioRoomController.waktuPerjalanan.value)),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: progressDoaController.doaStatuses
                          .asMap()
                          .entries
                          .map((entry) {
                        // Ambil data doa
                        var doa = entry.value;
                        int index = entry.key;
                        String title = doa['judul_doa'];
                        String time = doa['durasi_doa'];
                        bool isLastItem = index ==
                            progressDoaController.doaStatuses.length - 1;
                        print('ini durasi $time');

                        bool isFinished = audioRoomController
                            .playerController.isFinished.value;

                        bool isCompleted = isFinished
                            ? audioRoomController
                                        .playerController.currentIndex.value +
                                    1 >=
                                index
                            : audioRoomController
                                    .playerController.currentIndex.value >=
                                index;

                        bool isCurrent = isFinished
                            ? audioRoomController
                                        .playerController.currentIndex.value +
                                    1 ==
                                index
                            : audioRoomController
                                    .playerController.currentIndex.value ==
                                index;

                        return buildTimelineTile(
                          context,
                          title,
                          time,
                          isCompleted,
                          isCurrent: isCurrent,
                          isLastItem: isLastItem,
                        );
                      }).toList(),
                    );
                  }),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FutureBuilder<String?>(
                    future: SharedPreferencesService.getRole(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }

                      if (snapshot.hasError) {
                        return const SizedBox.shrink();
                      }

                      final role = snapshot.data;

                      // if (role == "ustadz") {
                      //   return SizedBox(
                      //     width: MediaQuery.of(context).size.width / 2.2,
                      //     child: WCustomButton(
                      //       verticalPadding: 10,
                      //       buttonText: 'Akhiri Perjalanan',
                      //       buttonColor: const Color(0xFFD30509),
                      //       onPressed: () => Get.dialog(
                      //         DialogEndRoom(
                      //             audioRoomController: audioRoomController),
                      //       ),
                      //     ),
                      //   );
                      // }
                      if (role == "ustadz") {
                        return Obx(() {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: WCustomButton(
                              verticalPadding: 10,
                              buttonText: 'Akhiri Perjalanan',
                              buttonColor: playerController.isFinished.value
                                  ? const Color(0xFFD30509)
                                  : const Color(0xFFB1B1B1),
                              onPressed: playerController.isFinished.value
                                  ? () => Get.dialog(
                                        DialogEndRoom(
                                            audioRoomController:
                                                audioRoomController),
                                      )
                                  : () {
                                      Get.snackbar('Peringatan',
                                          'Rangkaian doa belum selesai.');
                                    },
                            ),
                          );
                        });
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget buildTimelineTile(
  BuildContext context,
  String title,
  String time,
  bool isCompleted, {
  bool isCurrent = false,
  bool isLastItem = false,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(isCurrent
                    ? 'assets/icon_point.png'
                    : (isCompleted
                        ? 'assets/icon_check.png'
                        : 'assets/icon_point.png')),
                scale: 2,
              ),
              color: isCurrent
                  ? GlobalColors.mainColor
                  : (isCompleted
                      ? const Color(0xFF25D158)
                      : const Color(0xFFB1B1B1)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // Garis vertikal
          if (!isLastItem)
            Container(
              width: 4,
              height: 80,
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isCurrent
                    ? GlobalColors.mainColor
                    : (isCompleted
                        ? const Color(0xFF25D158)
                        : const Color(0xFFB1B1B1)),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
        ],
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (time != '00:00')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDurasiSimple(time),
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isCurrent
                    ? GlobalColors.mainColor
                    : (isCompleted
                        ? const Color(0xFF25D158)
                        : const Color(0xFFB1B1B1)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isCurrent
                    ? 'Sedang Berlangsung'
                    : isCompleted
                        ? 'Selesai'
                        : 'Belum Dilaksanakan',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ],
  );
}
