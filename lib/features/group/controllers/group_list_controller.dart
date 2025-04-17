import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/features/group/models/check_group_model.dart';
import 'package:maqdis_connect/features/group/models/check_user_in_group.dart';
import 'package:maqdis_connect/features/group/services/group_service.dart';

class GroupListController extends GetxController {
  final GroupService _grupService = GroupService();
  RxList<CheckUserInGroupModel> groupUsers =
      <CheckUserInGroupModel>[].obs; // Observable list of group users
  RxBool isLoading = false.obs; // Observable for loading state
  Timer? _pollingTimer; // Timer for polling
  RxList<GroupModel> data = <GroupModel>[].obs;
  RxString errorMessage = ''.obs;
  RxBool load = true.obs;
  RxBool status = false.obs;
  RxBool loadVisibleJoinGrup = false.obs; // State untuk loading
  RxBool warningVisibleJoinGrup = false.obs;
  RxBool isJoinButtonVisible = true.obs;
  var groupUsersMap = <String, List<CheckUserInGroupModel>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    startPolling(); // Start polling
    fetchAndSaveGrupOnLoad();
    fetchAllGroupUsers();
  }

  // Start polling for new users every 2 seconds
  void startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      fetchAllGroupUsers();
    });
  }

  // Stop polling when the controller is closed
  void stopPolling() {
    if (_pollingTimer != null && _pollingTimer!.isActive) {
      _pollingTimer!.cancel();
      _pollingTimer = null;
      print('Polling stopped');
    }
  }

  // Fetch grup data from API
  void fetchAndSaveGrupOnLoad() async {
    print("Memulai pengambilan grup...");
    final result = await _grupService.getGrup();

    if (result != null && result.isNotEmpty) {
      print("Grup berhasil diambil.");
      data.assignAll(result);
      load.value = false;
      status.value = true;
    } else {
      print("Tidak ada grup yang diambil.");
      load.value = false;
      status.value = false;
    }
  }

  Future<void> fetchAllGroupUsers() async {
    for (var grup in data) {
      await fetchGroupUsersByGroupId(grup.grupid, isPolling: true);
    }
  }

  Future<void> fetchGroupUsersByGroupId(String groupId,
      {isPolling = false}) async {
    if (!isPolling) {
      isLoading(true); // Show loading circle only during initial fetch
    }
    try {
      final users = await _grupService.fetchGroupUsersByGroupId(groupId);
      // Update data peserta di Map berdasarkan groupId
      groupUsersMap[groupId] = users;
      print('Fetched ${users.length} users for group $groupId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Jika error 404, atur groupUsers untuk groupId ini ke daftar kosong
        groupUsersMap[groupId] = [];
        print(
            'Group not found (404), setting groupUsers to empty for group $groupId');
      } else {
        print('Error fetching group users by group id: $e');
      }
    } catch (e) {
      print('Error fetching group users by group id: $e');
    } finally {
      isLoading(false); // Sembunyikan loading indicator
    }
  }

  @override
  void onClose() {
    stopPolling();
    // cekLiveData();
    print('GrupController closed and polling stopped');
    super.onClose();
  }
}
