import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';

class DeleteAccountService {
  static final Dio _dio =
      Dio(BaseOptions(baseUrl: '${Endpoints.baseUrl2}/api'));

  // hapus akun
  static Future<Map<String, dynamic>> deleteAccount(
      String email, String reason) async {
    final token = await SharedPreferencesService.getToken();
    print('Menghapus akun dengan email: $email, alasan: $reason');

    try {
      final response = await _dio.delete(
        '/profile/delete-account',
        options: Options(
          headers: {
            'token': token,
          },
        ),
        data: {
          "email": email,
          "alasan": reason,
        },
      );

      print('Response dari server: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('ERROR saat menghapus akun:');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      print('Error Message: ${e.message}');

      return {
        "error": "Gagal menghapus akun. ${e.response?.data ?? e.message}"
      };
    } catch (e) {
      print("Unexpected Error: $e");
      return {"error": "Terjadi kesalahan tak terduga, coba lagi nanti."};
    }
  }
}
