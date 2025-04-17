import 'package:get/get.dart';
import 'package:maqdis_connect/features/splash_screen/controllers/user_checking_controller.dart';

class SplashScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserCheckingController>(() => UserCheckingController());
  }
}
