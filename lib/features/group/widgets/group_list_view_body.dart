import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_list_view_object.dart';
import 'package:maqdis_connect/core/enums/platform_enum.dart';
import 'package:maqdis_connect/core/utils/date_formatter.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/group/models/check_group_model.dart';
import 'package:maqdis_connect/features/group/controllers/group_list_controller.dart';
import 'package:maqdis_connect/features/group/widgets/dialog_join_group.dart';

class GroupListViewBody extends StatelessWidget {
  const GroupListViewBody({
    super.key,
    required this.controller,
    this.platform = PlatformEnum.mobile,
  });

  final GroupListController controller;
  final PlatformEnum platform;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: () async => controller.fetchAndSaveGrupOnLoad(),
        color: GlobalColors.mainColor,
        child: AnimationLimiter(
          child: platform != PlatformEnum.mobile
              ? MouseRegion(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 2.2),
                    padding: const EdgeInsets.only(top: 5),
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: controller.data.length,
                    itemBuilder: (BuildContext context, index) {
                      GroupModel grup = controller.data[index];
                      bool isFinished = grup.finishAt != null;
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        delay: const Duration(milliseconds: 100),
                        child: SlideAnimation(
                          duration: const Duration(milliseconds: 2500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          horizontalOffset: 30,
                          verticalOffset: 300,
                          child: FlipAnimation(
                            duration: const Duration(milliseconds: 3000),
                            curve: Curves.fastLinearToSlowEaseIn,
                            flipAxis: FlipAxis.y,
                            child: WListViewObject(
                              spacer: true,
                              maxLines: 2,
                              isExpandedBtn: isFinished,
                              trailingBtn: !isFinished,
                              buttonColor: isFinished
                                  ? Colors.green
                                  : GlobalColors.mainColor,
                              onPressed: isFinished
                                  ? () => Fluttertoast.showToast(
                                      msg:
                                          'Perjalanan ${grup.namaGrup} sudah selesai pada ${formatTanggal(grup.finishAt.toString())}')
                                  : () {
                                      Get.dialog(
                                        DialogJoinGroup(
                                            data: controller.data,
                                            index: index),
                                      );
                                    },
                              buttonText: isFinished
                                  ? 'Selesai pada ${formatTanggal(grup.finishAt.toString())}'
                                  : 'Gabung Di sini',
                              number: '${index + 1}',
                              title: grup.namaGrup,
                              customWidget: Obx(
                                () {
                                  int jumlahPeserta = controller
                                          .groupUsersMap[grup.grupid]?.length ??
                                      0;
                                  debugPrint('Jumlah peserta: $jumlahPeserta');
                                  if (!isFinished) {
                                    return Text(
                                      '$jumlahPeserta peserta',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFB1B1B1),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 5),
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  clipBehavior: Clip.none,
                  itemCount: controller.data.length,
                  itemBuilder: (BuildContext context, index) {
                    GroupModel grup = controller.data[index];
                    bool isFinished = grup.finishAt != null;
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      delay: const Duration(milliseconds: 100),
                      child: SlideAnimation(
                        duration: const Duration(milliseconds: 2500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        horizontalOffset: 30,
                        verticalOffset: 300,
                        child: FlipAnimation(
                          duration: const Duration(milliseconds: 3000),
                          curve: Curves.fastLinearToSlowEaseIn,
                          flipAxis: FlipAxis.y,
                          child: WListViewObject(
                            isExpandedBtn: isFinished,
                            trailingBtn: !isFinished,
                            buttonColor: isFinished
                                ? Colors.green
                                : GlobalColors.mainColor,
                            onPressed: isFinished
                                ? () => Fluttertoast.showToast(
                                    msg:
                                        'Perjalanan ${grup.namaGrup} sudah selesai pada ${formatTanggal(grup.finishAt.toString())}')
                                : () {
                                    Get.dialog(
                                      DialogJoinGroup(
                                          data: controller.data, index: index),
                                    );
                                  },
                            buttonText: isFinished
                                ? 'Selesai pada ${formatTanggal(grup.finishAt.toString())}'
                                : 'Gabung Di sini',
                            number: '${index + 1}',
                            title: grup.namaGrup,
                            customWidget: Obx(
                              () {
                                int jumlahPeserta = controller
                                        .groupUsersMap[grup.grupid]?.length ??
                                    0;
                                debugPrint('Jumlah peserta: $jumlahPeserta');
                                if (!isFinished) {
                                  return Text(
                                    '$jumlahPeserta peserta',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFFB1B1B1),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
