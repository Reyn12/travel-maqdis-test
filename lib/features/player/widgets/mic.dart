import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/player/controllers/audio_room_controller.dart';

class Mic extends StatefulWidget {
  final AudioRoomController audioRoomController;

  const Mic({
    super.key,
    required this.audioRoomController,
  });

  @override
  State<Mic> createState() => _MicState();
}

class _MicState extends State<Mic> {
  bool micStatus = true;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WCustomButton(
        iconOnly: true,
        verticalPadding: 10,
        horizontalPadding: 12,
        iconSize: 21,
        icon: widget.audioRoomController.isMicrophoneMuted.value
            ? Icons.mic_off
            : Icons.mic,
        iconColor: Colors.white,
        buttonColor: widget.audioRoomController.isMicrophoneMuted.value
            ? const Color(0xFFD30509)
            : GlobalColors.mainColor,
        onPressed: () {
          widget.audioRoomController
              .toggleMic(); // Panggil method toggleMic di controller
        },
      ),
    );
  }
}
