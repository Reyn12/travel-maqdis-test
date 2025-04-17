import 'dart:async';

import 'package:get/get.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/group/controllers/group_controller.dart';
import 'package:maqdis_connect/features/group/services/live_progress_service.dart';

class WaitingPollsController extends GetxController {
  final LiveProgressServices _liveProgressServices = LiveProgressServices();
  final GroupController? _groupController =
      Get.isRegistered<GroupController>() ? Get.find<GroupController>() : null;
  Timer? _pollingTimer;
  final pollingInterval = const Duration(seconds: 5);
  var isPollingActive = false.obs;
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    print("🚀 Controller Ready! Memulai polling...");
    startCekLiveTimer();
  }

  @override
  onClose() {
    super.onClose();
    stopCekLiveTimer();
  }

  void startCekLiveTimer() {
    if (_pollingTimer != null) {
      print("⚠️ Timer sudah berjalan, tidak akan memulai ulang.");
      return;
    }

    isPollingActive.value = true;
    print("Timer dimulai, polling setiap ${pollingInterval.inSeconds} detik.");

    _pollingTimer = Timer.periodic(pollingInterval, (_) {
      print("Polling dijalankan...");
      _cekLive();
    });
  }

  void stopCekLiveTimer() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    isPollingActive.value = false;
    print('Timer stopped');
  }

  Future<void> _cekLive() async {
    if (!isPollingActive.value) return; // Jangan polling kalau sudah stop

    final currentGroupId = await SharedPreferencesService.getGroupId();
    final cekLiveResponse = await _liveProgressServices.getCekLive();
    await _groupController?.playerController.getRoomRefreshToken();

    if (cekLiveResponse == null || cekLiveResponse.data.isEmpty) {
      print('group tidak live saat ini');
      return;
    }

    final matchingData = cekLiveResponse.data.firstWhereOrNull(
        (item) => item.grupId == currentGroupId && item.live == 1);

    if (matchingData != null) {
      stopCekLiveTimer();
      _groupController?.stopPolling(); // Hentikan polling jika ketemu data
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      Future.microtask(() {
        isLoading.value = false;
        if (Get.currentRoute != '/audioRoomScreen') {
          Get.offAllNamed('/audioRoomScreen');
        }
      });
    }
  }
}
