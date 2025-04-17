import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_app_bar.dart';
import 'package:maqdis_connect/core/common/widgets/w_enum_loading_anim.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/controllers/group_history_controller.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/widgets/detail_perjalanan_body.dart';

class DetailPerjalananScreen extends StatefulWidget {
  const DetailPerjalananScreen({super.key});

  @override
  State<DetailPerjalananScreen> createState() => _DetailPerjalananScreenState();
}

class _DetailPerjalananScreenState extends State<DetailPerjalananScreen> {
  final GroupHistoryController controller = Get.find<GroupHistoryController>();

  @override
  void initState() {
    super.initState();
    controller.fetchPerjalanan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WCustomAppBar(
        centerTitle: true,
        title: 'Detail Perjalanan Anda',
      ),
      body: GetBuilder<GroupHistoryController>(
        id: 'tabController',
        builder: (controller) {
          if (controller.tabController == null ||
              controller.perjalananList.isEmpty) {
            return const Center(child: WEnumLoadingAnim());
          }

          return Column(
            children: [
              TabBar(
                onTap: (index) {
                  final selectedPerjalanan = controller.perjalananList[index];
                  controller
                      .setSelectedPerjalananId(selectedPerjalanan.perjalananId);
                  print(
                      'Selected perjalananId: ${selectedPerjalanan.perjalananId}');
                },
                controller: controller.tabController,
                tabs: controller.perjalananList
                    .map((p) => Tab(text: p.namaPerjalanan))
                    .toList(),
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
              ),
              // Memanggil detail perjalanan body
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List<Widget>.generate(
                    controller.perjalananList.length,
                    (index) {
                      return DetailPerjalananBody(controller: controller);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
