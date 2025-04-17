import 'package:get/get.dart';
import 'package:maqdis_connect/features/auth/views/reset_password_success_screen.dart';
import 'package:maqdis_connect/features/group/views/group_waiting_screen.dart';
import 'package:maqdis_connect/features/player/bindings/audio_room_binding.dart';
import 'package:maqdis_connect/features/player/views/audio_room_screen.dart';
import 'package:maqdis_connect/features/praktek/bindings/praktek_screen_binding.dart';
import 'package:maqdis_connect/features/praktek/views/praktek_screen_new.dart';
import 'package:maqdis_connect/features/profile/views/delete_account_success.screen.dart';
import 'package:maqdis_connect/features/splash_screen/bindings/splash_screen_binding.dart';
import 'package:maqdis_connect/features/splash_screen/views/splash_screen.dart';

class Routers {
  static final routes = [
    GetPage(
      name: '/splashScreen',
      page: () => SplashScreen(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: '/praktekScreen',
      page: () => const PraktekScreenNew(),
      binding: PraktekScreenBinding(),
    ),
    GetPage(
      name: '/waitingScreen',
      page: () => const GroupWaitingScreen(),
    ),
    GetPage(
      name: '/audioRoomScreen',
      page: () => const AudioRoomScreen(),
      binding: AudioRoomBinding(),
    ),
    GetPage(
      name: '/resetPasswordSuccess',
      page: () => const ResetPasswordSuccessScreen(),
    ),
    GetPage(
      name: '/deleteAccountSuccess',
      page: () => const DeleteAccountSuccessScreen(),
    ),
  ];
}
