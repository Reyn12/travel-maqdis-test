import 'package:get/get.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/room/models/room_model.dart';
import 'package:maqdis_connect/features/room/services/local/room_data.dart';
import 'package:maqdis_connect/features/room/services/room_service.dart';

class RoomController extends GetxController {
  final RoomServices _apiServiceRoom = RoomServices();

  // Observable untuk menyimpan status atau data room
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var roomData = Rxn<RoomModelResponse>();
  var authToken = ''.obs;

  @override
  void onReady() {
    super.onReady();
    // Panggil fungsi untuk mendapatkan token ketika halaman dibuka
    setAuthToken();
  }

  // Fungsi untuk memeriksa role dan mengambil data room jika role adalah 'user'
  Future<void> fetchRoomDataForUser() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final role = await SharedPreferencesService.getRole();

      // Jika role adalah 'user', maka hit API untuk mengambil data room
      if (role == 'user') {
        // Pastikan token sudah ada di SharedPreferences sebelum lanjut
        final token = await RoomDataSharedPreferenceService.getTokenSpeaker();

        if (token == null) {
          // Token tidak ada, jadi kita perlu mendapatkan token dulu dari API
          final response = await _apiServiceRoom.getRoomById();
          roomData.value = response;
          // Simpan token ke SharedPreferences
          await RoomDataSharedPreferenceService.saveTokenSpeakerUser(
              response.room.tokenSpeaker);
          print('Room Data: ${response.room.namaRoom}');
        } else {
          // Token sudah ada, lanjutkan penggunaan token
          print('Token sudah ada: $token');
        }
      } else {
        errorMessage.value =
            'Role bukan user. Tidak perlu mengambil data room.';
        print(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk mendapatkan token berdasarkan role
  Future<void> setAuthToken() async {
    isLoading.value = true; // Mulai loading
    try {
      final role = await SharedPreferencesService.getRole();

      if (role == 'user') {
        // Role user, hit API dan ambil token_listener
        final roomResponse = await _apiServiceRoom.getRoomById();
        authToken.value = roomResponse.room.tokenListener;
        print('User Role: Token Listener set to ${authToken.value}');
      } else if (role == 'ustadz') {
        // Role ustadz, ambil token_speaker dari SharedPreferences
        final tokenSpeaker =
            await RoomDataSharedPreferenceService.getTokenSpeaker();
        if (tokenSpeaker != null) {
          authToken.value = tokenSpeaker;
          print('Ustadz Role: Token Speaker set to ${authToken.value}');
        } else {
          errorMessage.value = 'Token Speaker tidak ditemukan.';
          print(errorMessage.value);
        }
      } else {
        errorMessage.value = 'Role tidak dikenal.';
        print(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Error saat mengambil token: $e';
      print(errorMessage.value);
    } finally {
      isLoading.value = false; // Selesai loading
    }
  }
}
