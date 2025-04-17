import 'package:get/get.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/group/services/group_service.dart';

class UserStatusController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxBool isOnline = false.obs;
  // Menyimpan status online/offline berdasarkan userId
  RxMap<String, bool> userStatusMap =
      <String, bool>{}.obs; // Menyimpan status berdasarkan userId

  // Mendapatkan userId secara otomatis
  Future<String?> getUserId() async {
    return await SharedPreferencesService
        .getIdUser(); // Return the userId directly
  }

  // Method untuk mengatur status Online
  Future<void> setStatusOnline() async {
    print('Memulai setStatusOnline...');
    isLoading.value = true;
    try {
      final userId = await getUserId(); // Mendapatkan userId secara asinkron
      print('User ID ditemukan: $userId'); // Debugging
      if (userId == null) {
        print('User ID tidak ditemukan');
        return;
      }

      // Panggil service untuk set Online
      final success = await GroupService().setStatusOnline();
      if (success) {
        userStatusMap[userId] = true; // Menandai user sebagai online
        print('Status $userId telah diperbarui menjadi Online.');
      } else {
        print('Gagal memperbarui status $userId menjadi Online.');
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      print('Terjadi kesalahan saat memperbarui status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk mengatur status Offline
  Future<void> setStatusOffline() async {
    isLoading.value = true;
    try {
      final userId = await getUserId(); // Mendapatkan userId secara asinkron
      if (userId == null) {
        print('User ID tidak ditemukan');
        return;
      }

      // Panggil service untuk set Offline
      final success = await GroupService().setStatusOffline();
      if (success) {
        userStatusMap[userId] = false; // Menandai user sebagai offline
        print('Status $userId telah diperbarui menjadi Offline.');
      } else {
        print('Gagal memperbarui status $userId menjadi Offline.');
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      print('Terjadi kesalahan saat memperbarui status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Cek status online atau offline berdasarkan userId
  Future<bool> isUserOnline() async {
    final userId = await getUserId(); // Mendapatkan userId secara asinkron
    return userStatusMap[userId] ??
        false; // Default ke offline jika belum ada status
  }

  void setOnlien() {
    isOnline.value = true;
  }

  void setOffline() {
    isOnline.value = false;
  }
}
