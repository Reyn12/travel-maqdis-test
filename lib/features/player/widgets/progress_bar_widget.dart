import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/player/controllers/player_controller.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PlayerControllerTesting controller =
        Get.find<PlayerControllerTesting>();
    return StreamBuilder<Duration?>(
      stream: controller.audioPlayer.positionStream,
      builder: (context, snapshot) {
        return ProgressBar(
          barHeight: 3,
          progress: snapshot.data ?? Duration.zero,
          buffered: controller.audioPlayer.bufferedPosition,
          progressBarColor: GlobalColors.mainColor,
          bufferedBarColor: Colors.grey.shade400,
          baseBarColor: const Color(0xFFE9E9E9),
          thumbColor: GlobalColors.mainColor,
          thumbRadius: 5,
          thumbGlowRadius: 0,
          timeLabelPadding: 2,
          timeLabelTextStyle: GoogleFonts.lato(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: GlobalColors.mainColor,
          ),
          total: controller.audioPlayer.duration ?? Duration.zero,
          onSeek: (duration) {
            controller.seekAudio(duration);
          },
        );
      },
    );
  }
}
