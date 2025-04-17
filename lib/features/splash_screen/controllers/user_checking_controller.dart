import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/navbar/home.dart';
import 'package:maqdis_connect/features/auth/views/imports/login_screen.dart';
import 'package:maqdis_connect/features/auth/views/register_landing_screen.dart';
import 'package:maqdis_connect/features/splash_screen/services/user_checking_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCheckingController extends GetxController {
  final userCheckingService = UserCheckingService();
  var showLogo = false.obs;
  var isLoading = false.obs;
  var logoOpacity = 0.0.obs;
  var loadingOpacity = 0.0.obs;

  @override
  onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 1), () {
      // checkLoginStatus();
      startSplashAnimation();
    });
  }

  Future<void> checkLoginStatus() async {
    isLoading.value = true;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final isTokenValid = await userCheckingService.checkTokenValid();
      if (!isTokenValid) {
        print('Token expired, removing...');
        await prefs.remove('token');
        Get.offAll(() => const LoginScreen());
      } else {
        print('Token valid, navigating to Home...');
        Get.offAll(() => Home());
      }
    } else {
      print('No valid token, staying on login screen.');
      Get.offAll(() => const LoginScreen());
    }

    isLoading.value = false;
  }

  Future<void> checkIfUserIsFirstTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final isUserFirstTimer = prefs.getBool('user_first_timer') ?? true;

    if (isUserFirstTimer) {
      Get.to(() => const RegisterLandingScreen());
      prefs.setBool('user_first_timer', false);
    } else {
      await checkLoginStatus();
    }
  }

  void startSplashAnimation() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      showLogo.value = true;
      logoOpacity.value = 1.0;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      isLoading.value = true;
      loadingOpacity.value = 1.0;
      Future.delayed(const Duration(seconds: 1), () {
        checkIfUserIsFirstTimer(); // Pindahkan proses pengecekan ke sini
      });
    });
  }
}
