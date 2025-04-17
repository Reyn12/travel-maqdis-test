import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/models/group_history_model.dart';

class GroupHistoryService {
  final Dio _dio = Dio(BaseOptions(baseUrl: '${Endpoints.baseUrl2}/api'));

  Future<List<RiwayatGrup>?> getAllGrupByToken() async {
    String? token = await SharedPreferencesService.getToken();

    if (token == null || token.isEmpty) {
      print('Token tidak ditemukan di SharedPreferences');
      throw Exception('Token tidak ditemukan');
    }

    try {
      final response = await _dio.get(
        '/riwayat',
        options: Options(
          headers: {
            "token": token,
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        List<dynamic> dataList = response.data['data'];

        return dataList.map((e) => RiwayatGrup.fromJson(e)).toList();
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching group history: $e");
      return null;
    }
  }
}
