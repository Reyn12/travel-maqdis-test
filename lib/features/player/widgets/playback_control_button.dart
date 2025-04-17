import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/features/player/controllers/player_controller.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

class PlaybackControlButton extends StatelessWidget {
  const PlaybackControlButton({Key? key, required this.controller})
      : super(key: key);

  final PlayerControllerTesting controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const WCustomButton(
          iconOnly: true,
          verticalPadding: 10,
          horizontalPadding: 12,
          iconSize: 21,
          icon: MingCuteIcons.mgc_loading_4_line,
          iconColor: Colors.blue,
          buttonColor: Color(0xFFE9E9E9),
        ); // Tampilkan loading jika audio sedang dimuat
      } else if (!controller.isPlaying.value) {
        return WCustomButton(
          iconOnly: true,
          verticalPadding: 10,
          horizontalPadding: 12,
          iconSize: 21,
          icon: MingCuteIcons.mgc_play_fill,
          iconColor: Colors.blue,
          buttonColor: const Color(0xFFE9E9E9),
          onPressed: controller.playAudio,
        );
      } else {
        return WCustomButton(
          iconOnly: true,
          verticalPadding: 10,
          horizontalPadding: 12,
          iconSize: 21,
          icon: MingCuteIcons.mgc_pause_fill,
          iconColor: Colors.blue,
          buttonColor: const Color(0xFFE9E9E9),
          onPressed: controller.pauseAudio,
        );
      }
    });
  }
}
