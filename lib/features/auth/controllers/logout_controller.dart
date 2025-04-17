import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/features/auth/services/auth_service.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';

class LogoutController extends GetxController {
  final AuthService _logoutService = AuthService();
  RxBool isLogout = false.obs;

  Future<void> logout() async {
    isLogout.value = true;
    try {
      // Check login type
      final loginType =
          await SharedPreferencesService.getLoginType(); // 'google' or 'api'

      if (loginType == 'google') {
        // Logout from Firebase if login type was Google
        await _logoutService.logoutFromGoogle();
      } else if (loginType == 'api') {
        // Logout from API if login type was custom API-based
        await _logoutService.logoutFromAPI();
      } else {
        print('No valid login type found.');
      }
      isLogout.value = false;

      // Clear all shared preferences
      await SharedPreferencesService.clearAllSharedPreferences();

      // Show toast message on successful logout
      await Fluttertoast.showToast(msg: 'Anda telah keluar');
    } catch (e) {
      isLogout.value = false;
      print('Logout failed: $e');
      // Show error toast if logout fails
      await Fluttertoast.showToast(msg: 'Terjadi kesalahan saat keluar');
    }
  }
}
