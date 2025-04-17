import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:maqdis_connect/features/beranda/models/perjalanan_model.dart';
import 'package:maqdis_connect/features/group/services/perjalanan_service.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/models/group_history_model.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/models/perjalanan_history_model.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/services/group_history_service.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/services/perjalanan_history_service.dart';

class GroupHistoryController extends GetxController
    with GetTickerProviderStateMixin {
  TabController? tabController;
  final GroupHistoryService _groupHistoryService = GroupHistoryService();
  final RiwayatPerjalananService _riwayatPerjalananService =
      RiwayatPerjalananService();
  final PerjalananService _perjalananService = PerjalananService();

  var groupHistoryList = <RiwayatGrup>[].obs;
  var perjalananList = <PerjalananModel>[].obs;
  var selectedRiwayatGrupId = "".obs;
  var selectedPerjalananId = "".obs;
  var perjalananDetail = Rxn<RiwayatPerjalanan>();

  @override
  void onInit() {
    super.onInit();
    fetchGroupHistory();
    fetchPerjalanan();
  }

  /// Fetch daftar grup riwayat perjalanan
  Future<void> fetchGroupHistory() async {
    try {
      final groups = await _groupHistoryService.getAllGrupByToken();
      if (groups != null && groups.isNotEmpty) {
        groupHistoryList.assignAll(groups);
        selectedRiwayatGrupId.value = groups.first.riwayatGrupId;
        fetchRiwayatPerjalananDetail();
      }
    } catch (error) {
      print("Error fetching group history: $error");
    }
  }

  /// Fetch daftar perjalanan dan update TabBar
  Future<void> fetchPerjalanan() async {
    try {
      final perjalananData = await _perjalananService.getPerjalanan();
      if (perjalananData.isNotEmpty) {
        perjalananList.assignAll(perjalananData);

        Future.delayed(Duration.zero, () {
          tabController =
              TabController(length: perjalananList.length, vsync: this);
          selectedPerjalananId.value = perjalananList.first.perjalananId;
          fetchRiwayatPerjalananDetail();
          update(['tabController']); // Update UI jika pakai GetBuilder
        });
      }
    } catch (error) {
      print("Error fetching perjalanan: $error");
    }
  }

  /// Set grup riwayat yang dipilih
  void setSelectedRiwayatGrupId(String grupId) {
    selectedRiwayatGrupId.value = grupId;
    fetchRiwayatPerjalananDetail();
  }

  /// Set perjalanan yang dipilih
  void setSelectedPerjalananId(String perjalananId) {
    selectedPerjalananId.value = perjalananId;
    fetchRiwayatPerjalananDetail();
  }

  /// Fetch detail perjalanan berdasarkan grup & perjalanan yang dipilih
  Future<void> fetchRiwayatPerjalananDetail() async {
    if (selectedRiwayatGrupId.isEmpty || selectedPerjalananId.isEmpty) return;

    try {
      final detail = await _riwayatPerjalananService.getRiwayatPerjalananDetail(
          selectedRiwayatGrupId.value, selectedPerjalananId.value);

      perjalananDetail.value = detail; // Gunakan .value
      update();
    } catch (error) {
      print("Error fetching perjalanan detail: $error");
    }
  }
}
