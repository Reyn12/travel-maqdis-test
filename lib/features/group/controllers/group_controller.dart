import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/group/models/check_group_model.dart';
import 'package:maqdis_connect/features/group/models/check_user_in_group.dart';
import 'package:maqdis_connect/features/group/models/generate_room_code.dart';
import 'package:maqdis_connect/features/group/services/group_service.dart';
import 'package:maqdis_connect/features/room/controllers/player-Controller/room_refresh_token_controller.dart';

class GroupController extends GetxController {
  final playerController = Get.put(RoomRefreshTokenController());
  final GroupService _grupService = GroupService();
  RxList<CheckUserInGroupModel> groupUsers =
      <CheckUserInGroupModel>[].obs; // Observable list of group users
  RxBool isLoading = false.obs; // Observable for loading state
  RxString role = ''.obs; // Observable for user role
  Timer? _pollingTimer; // Timer for polling
  RxString errorMessage = ''.obs;
  RxList<GroupModel> data = <GroupModel>[].obs;
  RxBool load = true.obs;
  RxBool status = false.obs;
  RxBool loadVisibleJoinGrup = false.obs; // State untuk loading
  RxBool warningVisibleJoinGrup = false.obs;
  RxBool isJoinButtonVisible = true.obs;
  Completer<bool>? _joinGrupCompleter;
  // Timer? _timer;
  // final bool _isPageActive = true;
  RxBool isWaitingScreenActive = false.obs;
  RxBool isLive = false.obs;
  // RxBool isAudioRoomActive = false.obs;
  final RxBool isNavigated = false.obs;
  RxBool isPollingActive = false.obs;
  Duration pollingInterval = const Duration(seconds: 5);
  RxString groupName = ''.obs;
  var tokenSpeaker = RxnString();
  var roomCode = Rxn<RoomCodeModel>();

  @override
  void onInit() {
    super.onInit();
    print('onInit started');
    fetchRole(); // Fetch role at the start
    fetchGroupUsers(); // Initial fetch without polling
    startPolling(); // Start polling
    _fetchAndSaveGrupOnLoad();
  }

  // Fetch the role from SharedPreferencesService
  Future<void> fetchRole() async {
    print('Fetching role...'); // Tambahkan log ini
    try {
      final fetchedRole = await SharedPreferencesService.getDataUser();
      role.value = fetchedRole.role;
      print('Fetched role: ${fetchedRole.role}');
    } catch (e) {
      print('Error fetching role: $e');
      role.value = '';
    }
  }

  // Start polling for new users every 2 seconds
  void startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      fetchGroupUsers(isPolling: true);
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
  void _fetchAndSaveGrupOnLoad() async {
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

  Future<void> fetchGroupName() async {
    try {
      final namaGrup = await SharedPreferencesService.getGroupName();
      groupName.value =
          namaGrup?.trim().isNotEmpty == true ? namaGrup! : 'group';
    } catch (e) {
      print("Error fetching group name: $e");
      groupName.value = 'group';
    }
  }

  Future<void> fetchAllGroupUsers() async {
    for (var grup in data) {
      await fetchGroupUsersByGroupId(grup.grupid);
    }
  }

  Future<void> fetchGroupUsersByGroupId(String groupId) async {
    isLoading.value = true; // Tampilkan loading indicator
    try {
      final users = await _grupService.fetchGroupUsersByGroupId(groupId);
      groupUsers.assignAll(users); // Update daftar peserta
      print('Fetched ${users.length} users for group $groupId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Jika error 404, atur groupUsers ke daftar kosong
        groupUsers.assignAll([]);
        print('Group not found (404), setting groupUsers to empty');
      } else {
        print('Error fetching group users by group id: $e');
      }
    } catch (e) {
      print('Error fetching group users by group id: $e');
    } finally {
      isLoading.value = false; // Sembunyikan loading indicator
    }
  }

  Future<void> fetchGroupUsers({bool isPolling = false}) async {
    if (!isPolling) {
      isLoading.value = true; // Tampilkan loading hanya saat fetch pertama
    }

    try {
      final response = await GroupService().fetchGroupUsers();

      // Assign user list to observable
      groupUsers.assignAll(response.users);

      // Jika perlu menyimpan roomId, simpan ke variabel yang bisa digunakan di UI
      if (response.roomId != null) {
        await SharedPreferencesService.saveRoomid(response.roomId ?? '');
      }

      print('✅ Group users fetched successfully: ${groupUsers.length}');
      print('📌 Room ID: ${response.roomId}');
    } catch (e) {
      print('❌ Error fetching group users: $e');
    } finally {
      if (!isPolling) {
        isLoading.value = false; // Hilangkan loading setelah fetch pertama
      }
    }
  }

  @override
  void onClose() {
    stopPolling();
    print('GrupController closed and polling stopped');
    super.onClose();
  }

  // Join grup
  Future<bool> joinGrup(String grupId, String grupName) async {
    loadVisibleJoinGrup.value = true;
    warningVisibleJoinGrup.value = false;
    isLoading.value = true;
    isJoinButtonVisible.value = false;

    _joinGrupCompleter = Completer<bool>();

    await Future.delayed(const Duration(seconds: 5));

    try {
      if (!_joinGrupCompleter!.isCompleted) {
        final success = await GroupService().joinGrup(grupId);
        if (success) {
          Get.snackbar('Berhasil', 'Anda berhasil bergabung dengan grup.');
          await SharedPreferencesService.saveGroupId(
              grupId); // Simpan grupId ke SharedPreferences
          print('ini nama grupnya $grupName');
          await SharedPreferencesService.saveGroupName(grupName);
          loadVisibleJoinGrup.value = false;
          warningVisibleJoinGrup.value = false;
          _joinGrupCompleter!.complete(true);
          return true; // Mengembalikan nilai true jika berhasil
        } else {
          Get.snackbar('Gagal', 'Gagal bergabung dengan grup.');
          loadVisibleJoinGrup.value = false;
          warningVisibleJoinGrup.value = true;
          _joinGrupCompleter!
              .complete(false); // Selesaikan Completer dengan false
          return false;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      loadVisibleJoinGrup.value = false;
      warningVisibleJoinGrup.value = true;
      errorMessage.value = 'Terjadi kesalahan: $e';
      _joinGrupCompleter!.complete(false);
      return false; // Mengembalikan false jika terjadi error
    } finally {
      isLoading.value = false;
      isJoinButtonVisible.value = true;
    }

    return false;
  }

  // Method untuk membatalkan proses join grup
  void cancelJoinGrup() {
    if (_joinGrupCompleter != null && !_joinGrupCompleter!.isCompleted) {
      _joinGrupCompleter!
          .complete(false); // Batalkan proses dengan menyelesaikan Completer
    }
  }

  Future<void> getRoomCode() async {
    try {
      isLoading.value = true;
      final data = await _grupService.fetchRoomCode();
      roomCode.value = data;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Exit grup
  Future<bool> exitGrup() async {
    isLoading.value = true;
    try {
      final success = await GroupService().exitGrup();
      if (success) {
        Get.snackbar('Berhasil', 'Anda berhasil keluar dari grup.');
        Get.offNamedUntil('/praktekScreen', (route) => route.isFirst);
        return true; // Mengembalikan nilai true jika berhasil
      } else {
        print('Gagal, keluar dari grup.');
        return false; // Mengembalikan nilai false jika gagal
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      print('Error Terjadi kesalahan saat keluar dari grup.');
      return false; // Mengembalikan false jika terjadi error
    } finally {
      isLoading.value = false;
    }
  }
}
