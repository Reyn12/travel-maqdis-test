import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/features/player/controllers/audio_room_controller.dart';
import 'package:maqdis_connect/features/player/controllers/player_controller.dart';
import 'package:maqdis_connect/features/player/widgets/mic.dart';
import 'package:maqdis_connect/features/player/widgets/dialog_change_doa.dart';
import 'package:maqdis_connect/features/player/widgets/dialog_settings_new.dart';
import 'package:maqdis_connect/features/player/widgets/playback_control_button.dart';
import 'package:maqdis_connect/features/player/widgets/progress_bar_widget.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

class AudioControls extends StatelessWidget {
  final PlayerControllerTesting controller;
  final AudioRoomController audioRoomController;

  const AudioControls(
      {super.key, required this.controller, required this.audioRoomController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Visibility(
            visible: !controller.isFinished.value,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: const ProgressBarWidget(),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Obx(() {
            bool isFirstPage = controller.currentIndex.value == 0;
            bool isLastPage =
                controller.currentIndex.value == controller.listpage.length - 1;
            if (audioRoomController.role!.value == 'ustadz') {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !controller.isFinished.value,
                    child: Row(
                      children: [
                        WCustomButton(
                          iconOnly: true,
                          verticalPadding: 10,
                          horizontalPadding: 12,
                          iconSize: 21,
                          icon: MingCuteIcons.mgc_settings_4_line,
                          iconColor: Colors.black,
                          buttonColor: const Color(0xFFE9E9E9),
                          onPressed: () => Get.dialog(
                            DialogSettingNew(playerController: controller),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.015),
                        PlaybackControlButton(controller: controller),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.015),
                      ],
                    ),
                  ),
                  audioRoomController.role?.value == 'ustadz'
                      ? Mic(audioRoomController: audioRoomController)
                      : const SizedBox.shrink(),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                  const SizedBox(
                    height: 25,
                    child: VerticalDivider(
                      width: 2,
                      thickness: 2,
                      color: Color(0xFFE9E9E9),
                    ),
                  ),
                  Visibility(
                    visible: !controller.isFinished.value,
                    child: Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.015),
                        WCustomButton(
                          trailing: false,
                          iconOnly: true,
                          icon: Icons.keyboard_arrow_left,
                          iconSize: 21,
                          iconColor: isFirstPage
                              ? const Color(0xFFB1B1B1)
                              : Colors.white,
                          verticalPadding: 10,
                          horizontalPadding: 12,
                          buttonColor: isFirstPage
                              ? const Color(0xFFE9E9E9)
                              : controller.isFinished.value
                                  ? const Color(0xFFB1B1B1)
                                  : const Color(0xFF25D158),
                          onPressed: isFirstPage
                              ? null // Disable tombol jika halaman awal
                              : controller.isFinished.value
                                  ? null
                                  : () {
                                      Get.dialog(
                                        DialogChangeDoa(
                                          title: 'sebelumnya',
                                          buttonTextRight: 'Kembali',
                                          onPressedRight: () {
                                            Navigator.pop(context);
                                            controller.previousPage();
                                            audioRoomController
                                                .updateCurrentPage(controller
                                                    .currentIndex.value);
                                            print(
                                                "Halaman sebelumnya: ${controller.currentIndex.value}");
                                          },
                                        ),
                                      );
                                    },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                  WCustomButton(
                    trailing: false,
                    iconOnly: true,
                    icon: isLastPage
                        ? MingCuteIcons.mgc_flag_3_fill
                        : Icons.keyboard_arrow_right,
                    iconSize: 21,
                    iconColor: Colors.white,
                    verticalPadding: 10,
                    horizontalPadding: 12,
                    buttonColor: isLastPage
                        ? (controller.isFinished.value
                            ? Colors.grey
                            : Colors.red)
                        : const Color(0xFF25D158),
                    onPressed: isLastPage
                        ? (controller.isFinished.value
                            ? null
                            : () {
                                controller.finishPage();
                                audioRoomController.updateCurrentPage(
                                    controller.currentIndex.value,
                                    isFinished: true);
                              })
                        : () {
                            Get.dialog(
                              DialogChangeDoa(
                                title: 'selanjutnya',
                                buttonTextRight: 'Lanjut',
                                onPressedRight: () {
                                  Navigator.pop(context);
                                  controller.nextPage();
                                  audioRoomController.updateCurrentPage(
                                      controller.currentIndex.value);
                                  print(
                                      "Halaman berikutnya: ${controller.currentIndex.value}");
                                },
                              ),
                            );
                          },
                  )
                ],
              );
            }
            return Visibility(
              visible: !controller.isFinished.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WCustomButton(
                    iconOnly: true,
                    verticalPadding: 10,
                    horizontalPadding: 12,
                    iconSize: 21,
                    icon: MingCuteIcons.mgc_settings_4_line,
                    iconColor: Colors.black,
                    buttonColor: const Color(0xFFE9E9E9),
                    onPressed: () => Get.dialog(
                      DialogSettingNew(playerController: controller),
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      PlaybackControlButton(controller: controller),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
