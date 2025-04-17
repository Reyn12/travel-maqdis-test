import 'package:get/get.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/group/models/check_group_model.dart';
import 'package:maqdis_connect/features/group/services/group_service.dart';
import 'package:maqdis_connect/features/group/views/group_list_screen_new.dart';

class PraktekController extends GetxController {
  final GroupService _groupService = GroupService();

  var isLoading = false.obs;
  var grupId = ''.obs;
  var namaGrup = ''.obs;

  void handleGrupCheck() async {
    isLoading.value = true;

    try {
      // Ambil grupId lebih awal untuk menghindari redundant await
      final storedGrupId = await SharedPreferencesService.getGroupId() ?? '';
      grupId.value = storedGrupId;

      final cekUserGrup = await _groupService.getCekUserGrup();

      if (cekUserGrup != null &&
          cekUserGrup.message == "Pengguna ditemukan dalam grup") {
        Get.offNamed('/waitingScreen');
      } else {
        Get.to(() => const GroupListScreenNew());
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> getGroupNameById(String grupId) async {
    List<GroupModel>? grupList = await _groupService.getGrup();

    if (grupList != null) {
      GroupModel? grup = grupList.firstWhere(
        (grup) => grup.grupid == grupId,
        orElse: () => GroupModel(
          grupid: '',
          namaGrup: '',
          createdBy: '',
          createdAt: DateTime.now(),
          openUser: 0,
          status: '',
          userId: '',
          roomId: null,
          room: null,
        ),
      );

      if (grup.grupid.isNotEmpty) {
        return grup.namaGrup;
      } else {
        print("Grup dengan ID $grupId tidak ditemukan.");
        return null;
      }
    } else {
      print("Data grup tidak ditemukan.");
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _fetchAndSaveGrupOnLoad();
  }

  // fetch seluruh grup yang ada
  void _fetchAndSaveGrupOnLoad() async {
    isLoading.value = true;
    final result = await _groupService.getGrup();
    if (result != null) {
      print("Grup berhasil diambil.");
    } else {
      print("Tidak ada grup yang diambil.");
    }
    isLoading.value = false;
  }
}
