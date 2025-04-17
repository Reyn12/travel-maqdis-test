import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/player/controllers/audio_room_controller.dart';
import 'package:maqdis_connect/features/player/controllers/player_controller.dart';
import 'package:maqdis_connect/features/player/widgets/doa_finished_widget.dart';

class DoaPlayer extends StatelessWidget {
  final PlayerControllerTesting controller =
      Get.find<PlayerControllerTesting>();
  final AudioRoomController audioRoomController;

  DoaPlayer({super.key, required this.audioRoomController}) {
    // ever(controller.currentIndex, (_) {
    //   controller.playAudio();
    // });

    ever(controller.isFinished, (_) {
      controller.stopAudio();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.listpage.isEmpty) {
        return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: GlobalColors.mainColor, size: 30));
      }

      if (controller.isFinished.value) {
        return Center(
          child: DoaFinishedWidget(
            audioRoomController: audioRoomController,
          ),
        );
      }

      var data = controller.listpage[controller.currentIndex.value];

      return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(color: const Color(0xFFB1B1B1), width: 1),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    // Judul Praktek
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(10),
                      child: Text(
                        data['judul_doa'],
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: GlobalColors.mainColor,
                        ),
                      ),
                    ),
                    // Divider
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: const Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    // Ayat dan Terjemah
                    for (var ayat in data['ayat'])
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(10),
                            child: Obx(
                              () {
                                return Text(
                                  ayat['teks_ayat'],
                                  style: TextStyle(
                                    fontFamily: 'lpmq',
                                    fontSize: controller.arabicFontSize.value,
                                  ),
                                  textAlign: TextAlign.end,
                                );
                              },
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(10),
                            child: Obx(() {
                              return Text(
                                ayat['terjemahan'],
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize:
                                      controller.translationFontSize.value,
                                  color: const Color.fromARGB(255, 134, 101, 4),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
