import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/views/no_data_view.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_app_bar.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/controllers/group_history_controller.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/views/responsive/perjalanan_desktop_screen.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/views/responsive/perjalanan_mobile_screen.dart';

class PerjalananScreenNew extends StatefulWidget {
  PerjalananScreenNew({super.key});

  final GroupHistoryController controller = Get.put(GroupHistoryController());

  @override
  State<PerjalananScreenNew> createState() => _PerjalananScreenNewState();
}

class _PerjalananScreenNewState extends State<PerjalananScreenNew> {
  @override
  void initState() {
    super.initState();
    widget.controller.fetchGroupHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WCustomAppBar(
        centerTitle: true,
        title: 'Riwayat Perjalanan Anda',
        removeBackButton: true,
      ),
      body: Obx(
        () {
          if (widget.controller.groupHistoryList.isEmpty) {
            // memanggil tampilan no data, jika tidak ada riwayat perjalanan
            return const Center(
              child: NoDataView(
                title: 'Anda belum melakukan perjalanan',
                subtitle: 'Riwayat anda masih kosong',
              ),
            );
          }
          // menggunakan layout builder untuk responsivitas dengan lebar width > 1000
          return LayoutBuilder(builder: (context, constraints) {
            double width = constraints.maxWidth;
            return width > 1000
                ? PerjalananDesktopScreen(controller: widget.controller)
                : PerjalananMobileScreen(controller: widget.controller);
          });
        },
      ),
    );
  }
}
