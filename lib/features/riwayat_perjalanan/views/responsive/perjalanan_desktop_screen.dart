import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_list_view_object.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/controllers/group_history_controller.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/views/detail_perjalanan_screen.dart';

class PerjalananDesktopScreen extends StatelessWidget {
  const PerjalananDesktopScreen({super.key, required this.controller});

  final GroupHistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: AnimationLimiter(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.2,
          ),
          clipBehavior: Clip.none,
          itemCount: controller.groupHistoryList.length,
          itemBuilder: (BuildContext context, index) {
            final group = controller.groupHistoryList[index];
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    imageBackground: true,
                    divider: false,
                    onPressed: () {
                      controller.setSelectedRiwayatGrupId(group.riwayatGrupId);
                      Get.to(() => const DetailPerjalananScreen());
                    },
                    buttonText: 'Detail Perjalanan',
                    trailingBtn: false,
                    number: '${index + 1}',
                    title: group.namaGrup,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
