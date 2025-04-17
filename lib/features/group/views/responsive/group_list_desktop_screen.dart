import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/views/no_data_view.dart';
import 'package:maqdis_connect/core/common/widgets/w_enum_loading_anim.dart';
import 'package:maqdis_connect/core/enums/platform_enum.dart';
import 'package:maqdis_connect/features/group/controllers/group_list_controller.dart';
import 'package:maqdis_connect/features/group/widgets/group_list_view_body.dart';

class GroupListDesktopScreen extends StatefulWidget {
  const GroupListDesktopScreen({super.key, required this.controller});

  final GroupListController controller;

  @override
  State<GroupListDesktopScreen> createState() => _GroupListDesktopScreenState();
}

class _GroupListDesktopScreenState extends State<GroupListDesktopScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Obx(() {
        if (widget.controller.load.value) {
          return const Center(child: WEnumLoadingAnim());
        } else if (widget.controller.status.value) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GroupListViewBody(
                platform: PlatformEnum.desktop, controller: widget.controller),
          );
        } else {
          return const Center(
            child: NoDataView(
              title: 'Belum ada grup',
              subtitle: 'Tidak ada grup tersedia',
            ),
          );
        }
      }),
    );
  }
}
