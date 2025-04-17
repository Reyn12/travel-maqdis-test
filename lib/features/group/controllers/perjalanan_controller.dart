import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_enum_loading_anim.dart';
import 'package:maqdis_connect/features/beranda/models/perjalanan_model.dart';
import 'package:maqdis_connect/features/group/services/live_progress_service.dart';
import 'package:maqdis_connect/features/group/services/perjalanan_service.dart';

class PerjalananController extends GetxController with WidgetsBindingObserver {
  final PerjalananService _apiService = PerjalananService();

  // Reactive state for perjalanan data
  RxList<PerjalananModel> perjalananList = <PerjalananModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxBool isLive = false.obs;
  // Reactive state for selected jenis perjalanan
  RxString selectedJenisPerjalanan = ''.obs;
  final _cekLive = LiveProgressServices();
  var statusMap = <String, bool>{}.obs;
  // Method to fetch perjalanan data

  @override
  onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    await fetchPerjalanan();
    await cekStatusPerjalananByGroupId();

    ever(statusMap, (_) {
      print("Status perjalanan berubah, update UI!");
      update();
    });
  }

  @override
  void onReady() {
    super.onReady();
    cekStatusPerjalananByGroupId();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print("Aplikasi kembali dari background, cek status perjalanan lagi...");
      print("Sebelum Update: $statusMap");
      cekStatusPerjalananByGroupId();
      print("Sesudah Update: $statusMap");
    }
  }

  Future<void> fetchPerjalanan() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final perjalananData = await _apiService.getPerjalanan();
      perjalananList.assignAll(perjalananData);
      print("Sebelum Update: $statusMap");
      await cekStatusPerjalananByGroupId();
      print("Sesudah Update: $statusMap");
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cekStatusPerjalananByGroupId() async {
    try {
      print("Fetching status perjalanan...");
      isLoading.value = true;

      final perjalananList = await _cekLive.getCekStatusPerjalananByGroupId();
      Map<String, bool> tempStatusMap = {};

      for (var perjalanan in perjalananList) {
        tempStatusMap[perjalanan['jenis_perjalanan'].toLowerCase()] =
            perjalanan['is_finished'];
      }

      // Gunakan `.refresh()` agar benar-benar update ke UI
      statusMap.value = tempStatusMap;
      statusMap.refresh();
      update();

      print("Status perjalanan berhasil diperbarui!");
    } catch (e) {
      print("Error fetch status perjalanan: $e");
      errorMessage.value = "Gagal mengambil status perjalanan";
    } finally {
      isLoading.value = false;
      update(); // Pastikan UI benar-benar di-refresh
    }
  }

  Future<void> postProgress(String perjalananId) async {
    try {
      // Tampilkan dialog loading
      Get.dialog(
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: WEnumLoadingAnim(),
            ),
          ),
          barrierDismissible: false);

      // Kirim permintaan postProgress ke API
      final response = await _apiService.postProgress(perjalananId);

      // Pastikan kondisi live adalah 1
      if (response['data']['live'] == 1) {
        isLive.value = true; // Tandai status live

        print('Live status detected, calling cekLive()');

        // Panggil cekLive untuk mengarahkan semua anggota grup
        // await cekLive();
      } else {
        print('Live status not detected');
      }

      // Tutup dialog loading
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Fluttertoast.showToast(msg: 'Progress Dimulai');
    } catch (e) {
      // Tutup dialog loading jika ada error
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      print('Error in postProgress: $e');

      // Tampilkan pesan error
      Fluttertoast.showToast(msg: 'Gagal mengirim progress: $e');
    }
  }

// Method untuk mengatur jenis perjalanan yang dipilih
  void setSelectedJenisPerjalanan(String perjalananId) {
    selectedJenisPerjalanan.value = perjalananId;
  }
}
