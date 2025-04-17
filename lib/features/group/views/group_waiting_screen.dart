import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_button_exit.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_app_bar.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/core/common/widgets/w_loading_animation.dart';
import 'package:maqdis_connect/core/common/widgets/w_enum_loading_anim.dart';
import 'package:maqdis_connect/core/common/widgets/w_user_lengths.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/group/controllers/perjalanan_controller.dart';
import 'package:maqdis_connect/features/group/controllers/get_list_group_controller.dart';
import 'package:maqdis_connect/features/group/controllers/group_controller.dart';
import 'package:maqdis_connect/features/group/controllers/user_status_controller.dart';
import 'package:maqdis_connect/features/group/controllers/waiting_polls_controller.dart';
import 'package:maqdis_connect/features/group/views/responsive/group_waiting_desktop_screen.dart';
import 'package:maqdis_connect/features/group/views/responsive/group_waiting_mobile_screen.dart';
import 'package:maqdis_connect/features/group/widgets/build_role_based_content.dart';
import 'package:maqdis_connect/features/group/widgets/dialog_exit_group.dart';
import 'package:maqdis_connect/features/group/widgets/share_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

class GroupWaitingScreen extends StatefulWidget with WidgetsBindingObserver {
  const GroupWaitingScreen({Key? key}) : super(key: key);

  @override
  State<GroupWaitingScreen> createState() => _GroupWaitingScreenState();
}

class _GroupWaitingScreenState extends State<GroupWaitingScreen>
    with WidgetsBindingObserver {
  late final UserStatusController userStatusController;
  // final PerjalananController perjalananController =
  //     Get.put(PerjalananController());
  late final GetListGroupController groupControllerListGrup;
  final bool _isPageActive = true;
  final GroupController _groupController = Get.put(GroupController());
  final PerjalananController perjalananController =
      Get.put(PerjalananController());

  @override
  void initState() {
    super.initState();
    try {
      print('initState called');
      getPermissions();
      userStatusController = Get.put(UserStatusController());
      groupControllerListGrup = Get.put(GetListGroupController());
      Get.put(WaitingPollsController());
      // perjalananController.fetchPerjalanan();
      groupControllerListGrup.fetchRoomId();
      _groupController.fetchGroupName();
      _groupController.isWaitingScreenActive.value = _isPageActive;
      print(
          'isWaitingScreenActive: ${_groupController.isWaitingScreenActive.value}');
      userStatusController.setStatusOnline();
      WidgetsBinding.instance.addObserver(this);
    } catch (e) {
      print('Error in initState: $e');
    }
  }

  @override
  void dispose() {
    Get.delete<WaitingPollsController>();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = Get.find<WaitingPollsController>();
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      controller.stopCekLiveTimer(); // Stop polling saat minimize / lock
      _groupController.stopPolling();
      print("🔴 App Paused / Locked: Timer Stopped");
    } else if (state == AppLifecycleState.resumed) {
      controller.startCekLiveTimer(); // Lanjutkan polling saat dibuka kembali
      _groupController.startPolling();
      print("🟢 App Resumed: Timer Restarted");
    }
  }

  static Future<bool> getPermissions() async {
    if (Platform.isIOS) return true;

    await Permission.microphone.request();
    await Permission.bluetoothConnect.request();

    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
    while ((await Permission.bluetoothConnect.isDenied)) {
      await Permission.bluetoothConnect.request();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (Get.find<WaitingPollsController>().isPollingActive.value) {
            back();
          }
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, -3),
                        blurRadius: 4,
                        spreadRadius: 0,
                        color: const Color(0xFFB1B1B1).withOpacity(0.5))
                  ],
                ),
                child: Obx(() {
                  if (_groupController.role.value == 'ustadz') {
                    return Column(
                      children: [
                        BuildRoleBasedContent(
                          perjalananController: perjalananController,
                          onPressedBack: () => back(),
                        ),
                      ],
                    );
                  } else if (_groupController.role.value == 'user') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Menunggu pembimbing',
                                style: GoogleFonts.lato(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 14),
                              SizedBox(
                                height: 25,
                                width: 25,
                                child: WLoadingAnimation(
                                  color: GlobalColors.mainColor,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 25),
                          Obx(
                            () {
                              bool isPollingActive =
                                  !Get.find<WaitingPollsController>()
                                      .isPollingActive
                                      .value;
                              return WCustomButton(
                                onPressed:
                                    isPollingActive ? () {} : () => back(),
                                buttonText: 'Kembali',
                                fontColor: isPollingActive
                                    ? Colors.white
                                    : Colors.black,
                                buttonColor: isPollingActive
                                    ? Colors.grey.withOpacity(0.3)
                                    : Colors.white,
                                border: Border.all(
                                  color: isPollingActive
                                      ? Colors.grey.withOpacity(0.3)
                                      : Colors.black,
                                ),
                                fontSize: 16,
                                verticalPadding: 11,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(child: WEnumLoadingAnim()));
                  }
                }),
              ),
            ),
            appBar: WCustomAppBar(
              removeBackButton: true,
              customLeftWidget: true,
              leftWidget: Obx(
                () {
                  // final GroupController controller = Get.put(GroupController());
                  int memberCount = _groupController.groupUsers.length;
                  return WUserLengths(
                    memberCount: memberCount.toString(),
                  );
                },
              ),
              centerTitle: true,
              isReactive: true,
              titleWidget: Obx(() => Text(
                    _groupController.groupName.value,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )),
              customAction: true,
              actionWidget: WButtonExit(
                onTap: () => Get.dialog(
                  const DialogExitGroup(),
                ),
              ),
            ),
            floatingActionButton: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton(
                splashColor: GlobalColors.mainColor.withOpacity(0.2),
                enableFeedback: true,
                tooltip: 'Bagikan',
                elevation: 0, // Set 0 agar tidak tumpang tindih
                backgroundColor: Colors.white,
                onPressed: () async {
                  await _groupController.getRoomCode();
                  _showCustomBottomSheet(context);
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.ios_share_outlined),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: LayoutBuilder(builder: (context, constraints) {
                double width = constraints.maxWidth;
                return width > 1000
                    ? GroupWaitingDesktopScreen(
                        groupController: _groupController)
                    : GroupWaitingMobileScreen(
                        groupController: _groupController);
              }),
            ),
          ),
          Obx(() {
            final WaitingPollsController waitingPollsController =
                Get.find<WaitingPollsController>();
            if (waitingPollsController.isLoading.value) {
              return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: WEnumLoadingAnim()));
            }
            return const SizedBox.shrink();
          })
        ],
      ),
    );
  }

  void back() {
    userStatusController.setStatusOffline();
    Get.offAllNamed('/praktekScreen');
    Get.delete<GroupController>();
    Get.delete<UserStatusController>();
    Get.delete<PerjalananController>();
  }

  static void _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ShareBottomSheet(),
    );
  }
}
