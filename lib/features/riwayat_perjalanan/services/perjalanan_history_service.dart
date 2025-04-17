import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/models/perjalanan_history_model.dart';

class RiwayatPerjalananService {
  final Dio _dio = Dio(BaseOptions(baseUrl: '${Endpoints.baseUrl2}/api'));

  Future<RiwayatPerjalanan?> getRiwayatPerjalananDetail(
      String riwayatGrupId, String perjalananId) async {
    String? token = await SharedPreferencesService.getToken();

    if (token == null || token.isEmpty) {
      print('Token tidak ditemukan di SharedPreferences');
      throw Exception('Token tidak ditemukan');
    }

    try {
      final response = await _dio.get(
        '/riwayat/detail/$riwayatGrupId/$perjalananId',
        options: Options(
          headers: {
            "token": token,
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return RiwayatPerjalanan.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching perjalanan detail: $e");
      return null;
    }
  }
}
