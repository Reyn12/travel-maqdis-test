import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/navbar/home.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_app_bar.dart';
import 'package:maqdis_connect/core/common/widgets/w_enum_loading_anim.dart';
import 'package:maqdis_connect/features/praktek/controllers/praktek_controller.dart';
import 'package:maqdis_connect/features/praktek/views/responsive/praktek_desktop_screen.dart';
import 'package:maqdis_connect/features/praktek/views/responsive/praktek_mobile_screen.dart';

class PraktekScreenNew extends StatefulWidget {
  const PraktekScreenNew({super.key});

  @override
  State<PraktekScreenNew> createState() => _PraktekState();
}

class _PraktekState extends State<PraktekScreenNew> {
  final PraktekController _praktekController = Get.find<PraktekController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (!didPop) {
          Get.offUntil(
            GetPageRoute(page: () => Home()),
            (route) => route.isFirst,
          );
        }
      },
      canPop: false,
      child: Stack(
        children: [
          Scaffold(
            extendBodyBehindAppBar: true,
            appBar: WCustomAppBar(
              onPressed: () {
                Get.offUntil(
                  GetPageRoute(page: () => Home()),
                  (route) => route.isFirst,
                );
              },
              centerTitle: true,
              title: 'Mulai Umroh',
            ),
            // memanggil praktek screen
            body: LayoutBuilder(builder: (context, constraints) {
              double width = constraints.maxWidth;
              return width > 1000
                  ? PraktekDesktopScreen(praktekController: _praktekController)
                  : PraktekMobileScreen(praktekController: _praktekController);
            }),
          ),
          Obx(() {
            if (_praktekController.isLoading.value) {
              return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: WEnumLoadingAnim()));
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
