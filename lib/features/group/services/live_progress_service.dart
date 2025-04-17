import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/group/models/live_progress_model.dart';
import 'package:maqdis_connect/features/room/services/local/room_data.dart';

class LiveProgressServices {
  final Dio _dio = Dio();

  Future<LiveProgressModelResponse?> getCekLive() async {
    const String url = Endpoints.baseUrl2 + Endpoints.liveProgress;

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        print("Response API: ${response.data}");

        final liveProgressResponse =
            LiveProgressModelResponse.fromJson(response.data);

        if (liveProgressResponse.status &&
            liveProgressResponse.data.isNotEmpty) {
          // Filter data dengan live == 1
          final liveData = liveProgressResponse.data
              .where((item) => item.live == 1)
              .toList();

          print('Data yang live == 1: $liveData');

          if (liveData.isNotEmpty) {
            final idProgress = liveData[0].progressId;
            final idPerjalanan = liveData[0].perjalananId;

            print('id_progress: $idProgress, id_perjalanan: $idPerjalanan');

            final storedId =
                await RoomDataSharedPreferenceService.getProgressPerjalananId();
            print("storedId (sebelumnya): $storedId");

            if (storedId != idProgress) {
              print("Menyimpan id_progress baru: $idProgress");
              await RoomDataSharedPreferenceService.saveProgressPerjalananId(
                  idProgress);
              await RoomDataSharedPreferenceService.saveCurrentPerjalananId(
                  idPerjalanan);
            } else {
              print(
                  "ℹid_progress sudah ada di SharedPreferences, tidak perlu update.");
            }
          } else {
            await RoomDataSharedPreferenceService.clearProgressPerjalananId();
            print("Tidak ada data live == 1, id_progress dihapus.");
          }
        } else {
          print("Tidak ada data yang valid atau status false.");
        }

        return liveProgressResponse;
      } else {
        print("Error dari server: ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("Exception saat mengambil data: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCekStatusPerjalananByGroupId() async {
    final groupId = await SharedPreferencesService.getGroupId();
    final url = '${Endpoints.baseUrl2}api/Group/getStatusPerjalanan/$groupId';

    try {
      if (groupId == null || groupId.isEmpty) {
        print('groupId tidak ditemukan!');
        return [];
      }

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data['data'];
        return responseData.cast<Map<String, dynamic>>();
      } else {
        print(
            'Gagal mengambil status progress. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      return [];
    }
  }

  Future<bool> finishProgress() async {
    const url = '${Endpoints.baseUrl2}api/progress';
    print('mencoba finish progress');

    try {
      // Ambil progressId dari SharedPreferences
      final progressId =
          await RoomDataSharedPreferenceService.getProgressPerjalananId();
      print('finish Progress ID: $progressId');
      if (progressId == null || progressId.isEmpty) {
        print('Progress ID tidak ditemukan di SharedPreferences');
        return false;
      }

      // Ambil token dari SharedPreferences
      final token = await SharedPreferencesService.getToken();
      if (token == null) {
        print('Token tidak ditemukan di SharedPreferences');
        return false;
      }

      final response = await _dio.put(
        url,
        data: {
          'progressid': progressId,
        },
        options: Options(
          headers: {
            'token': token,
          },
        ),
      );

      print('Response status finishProgress: ${response.statusCode}');
      print('Response data finishProgress: ${response.data}');

      if (response.statusCode == 200) {
        print('Progress berhasil diselesaikan.');
        return true;
      } else {
        print('Gagal menyelesaikan progress. Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Terjadi kesalahan saat finish progress: $e');
      return false;
    }
  }
}
