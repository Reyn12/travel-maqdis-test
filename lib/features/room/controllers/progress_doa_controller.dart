import 'package:get/get.dart';
import 'package:maqdis_connect/features/room/services/local/room_data.dart';
import 'package:maqdis_connect/features/room/services/progress_doa_service.dart';

class ProgressDoaController extends GetxController {
  final ProgressDoaService _service = ProgressDoaService();
  var isLoading = false.obs;
  var progressData = {}.obs;
  var doaStatuses = <Map<String, dynamic>>[].obs;

  // mendapatkan status progress doa saat ini
  Future<void> fetchDoaStatus() async {
    try {
      isLoading.value = true;
      final perjalananId =
          await RoomDataSharedPreferenceService.getCurrentPerjalananId();
      final progressId =
          await RoomDataSharedPreferenceService.getProgressPerjalananId();

      if (perjalananId == null || perjalananId.isEmpty) {
        print('Perjalanan ID tidak ditemukan');
        return;
      }

      if (progressId == null || progressId.isEmpty) {
        print('Progress ID tidak ditemukan');
        return;
      }

      var doaStatus =
          await _service.fetchDoaTitlesByPerjalananId(perjalananId, progressId);
      doaStatuses.assignAll(doaStatus); // Simpan hasil ke dalam observable list
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // membuat progress doa by doaid
  Future<void> postProgressDoa(String doaId) async {
    final progressId =
        await RoomDataSharedPreferenceService.getProgressPerjalananId();
    try {
      isLoading.value = true;
      var response = await _service.postProgressDoa(progressId!, doaId);
      progressData.value = response;
      print('ini progressId untuk postProgressDoa: $progressId');
      print('progressData: $progressData');
    } catch (e) {
      // Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // mengupadte progress doa by progressdoaid
  Future<void> updateProgressDoa(String progressDoaId) async {
    print('ini progress doa id: $progressDoaId');
    try {
      isLoading.value = true;
      var response = await _service.updateProgressDoa(progressDoaId);
      progressData.value = response;
      print('response update progress doa : $response');
    } catch (e) {
      // Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
