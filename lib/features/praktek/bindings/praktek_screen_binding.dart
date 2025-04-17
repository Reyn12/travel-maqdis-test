import 'package:get/get.dart';
import 'package:maqdis_connect/features/praktek/controllers/praktek_controller.dart';

class PraktekScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PraktekController>(() => PraktekController());
  }
}
