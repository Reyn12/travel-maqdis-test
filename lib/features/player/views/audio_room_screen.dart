import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_app_bar.dart';
import 'package:maqdis_connect/core/common/widgets/w_enum_loading_anim.dart';
import 'package:maqdis_connect/core/common/widgets/w_user_lengths.dart';
import 'package:maqdis_connect/core/enums/loading_animation.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/player/controllers/audio_room_controller.dart';
import 'package:maqdis_connect/features/player/controllers/player_controller.dart';
import 'package:maqdis_connect/features/player/widgets/audio_controls.dart';
import 'package:maqdis_connect/features/player/widgets/daftar_peserta_widget.dart';
import 'package:maqdis_connect/features/player/widgets/doa_player.dart';
import 'package:maqdis_connect/features/player/widgets/progress_perjalanan_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioRoomScreen extends StatefulWidget {
  final String? from;
  final String? type;
  final List? grup;
  const AudioRoomScreen({this.from, this.type, this.grup, super.key});

  @override
  State<AudioRoomScreen> createState() => _AudioRoomState();
}

// class _AudioRoomState
//     extends State<AudioRoomScreen> /*implements HMSUpdateListener*/ {
//   final AudioRoomController controller = Get.put(AudioRoomController());

class _AudioRoomState extends State<AudioRoomScreen> {
  late final AudioRoomController controller;
  late final PlayerControllerTesting playerControllerTesting;
  String? namaGrup;
  // Get.put(AudioRoomController());

  @override
  void initState() {
    super.initState();
    // if (!Get.isRegistered<AudioRoomController>()) {
    controller = Get.find<AudioRoomController>();
    playerControllerTesting = Get.find<PlayerControllerTesting>();
    _loadGroupName();
    // }

    if (controller.firstOpen.value == false) {
      controller.firstOpen.value = true;
      // Lakukan inisialisasi lainnya jika perlu
    }
  }

  _loadGroupName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      namaGrup =
          prefs.getString('nama_grup') ?? 'Group'; // Default 'Group' jika null
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {},
      canPop: false,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: WCustomAppBar(
              centerTitle: true,
              title: namaGrup ?? 'Room',
              removeBackButton: true,
              customLeftWidget: true,
              leftWidget: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      controller.tabController.animateTo(1);
                    },
                    child: Obx(
                      () {
                        final memberCount = controller.listener.length +
                            controller.speaker.length;
                        return WUserLengths(
                          memberCount: memberCount.toString(),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // Bagian TabBar dan TabBarView
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          TabBar(
                            controller: controller.tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: GlobalColors.mainColor,
                            splashFactory: InkSparkle.splashFactory,
                            overlayColor: WidgetStatePropertyAll(
                                GlobalColors.mainColor.withOpacity(0.08)),
                            labelStyle: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: GlobalColors.mainColor,
                            ),
                            unselectedLabelStyle: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFB1B1B1),
                            ),
                            tabs: const [
                              Tab(text: 'Doa'),
                              Tab(text: 'Peserta'),
                              Tab(text: 'Perjalanan'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: controller.tabController,
                              children: [
                                SizedBox.expand(
                                    child: DoaPlayer(
                                  audioRoomController: controller,
                                )),
                                const DaftarPesertaWidget(),
                                ProgressPerjalananWidget(
                                  audioRoomController: controller,
                                ),
                              ],
                            ),
                          ),
                          Obx(() {
                            Widget child = AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: Container(
                                padding: playerControllerTesting
                                        .isFinished.value
                                    ? const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0)
                                    : const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                margin: playerControllerTesting.isFinished.value
                                    ? const EdgeInsets.only(bottom: 24)
                                    : EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      playerControllerTesting.isFinished.value
                                          ? BorderRadius.circular(16)
                                          : const BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                            ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: playerControllerTesting
                                              .isFinished.value
                                          ? const Offset(0, 4)
                                          : const Offset(0, -4),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                      color: const Color(0xFFB1B1B1)
                                          .withOpacity(0.5),
                                    ),
                                  ],
                                ),
                                child: AudioControls(
                                  controller: playerControllerTesting,
                                  audioRoomController: controller,
                                ),
                              ),
                            );

                            return playerControllerTesting.isFinished.value
                                ? controller.role!.value == 'ustadz'
                                    ? Center(
                                        child: IntrinsicWidth(
                                          child: IntrinsicHeight(
                                            child: child,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink()
                                : IntrinsicHeight(child: child);
                          }),
                        ],
                      ),
                    ),
                  ),
                  // const ModalBottomSheetPerjalanan(),
                ],
              ),
            ),
          ),
          Obx(() {
            if (controller.isPreparingHmsSDK.value) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: WEnumLoadingAnim(
                    animation: LoadingAnimation.stretchedDots,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
