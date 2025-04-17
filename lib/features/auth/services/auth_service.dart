import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';
import 'package:maqdis_connect/features/auth/models/login_model.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      followRedirects: true,
      validateStatus: (status) {
        return status! < 500; // Accept status codes <500
      },
    ),
  );

  /// Fungsi untuk mendaftarkan pengguna baru ke API
  Future<Map<String, dynamic>?> registerUser(
    String name,
    String email,
    String password,
    String whatsapp,
  ) async {
    const url = Endpoints.baseUrl2 + Endpoints.registerUrl;

    try {
      final response = await _dio.post<Map<String, dynamic>?>(
        url,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'whatsapp': whatsapp,
        },
      );

      if (response.statusCode == 200) {
        print(response.data); // Print successful registration response
        return response.data; // Return response data as Map
      } else {
        print('Registration failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      if (e.response != null) {
        // print('Response data: ${e.response?.data}');
        return {'error': e.response?.data};
      }
      return {'error': e.message};
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()};
    }
    return null;
  }

  /// Fungsi untuk login pengguna ke API dan menyimpan token
  Future<LoginModel?> connectApi(String email, String password) async {
    const url = Endpoints.baseUrl2 + Endpoints.loginUrl;

    try {
      final response = await _dio.post<Map<String, dynamic>?>(
        url,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final userLogin = LoginModel.fromJson(response.data!);
        print('response dari backend: ${response.data}');

        if (userLogin.status == 'success') {
          await SharedPreferencesService.simpanToken(userLogin.token);
          await SharedPreferencesService.saveIdRoleUser(
            userLogin.id,
            userLogin.username,
            userLogin.role,
            userLogin.photo,
            userLogin.email,
          );

          if (userLogin.groupId != null) {
            await SharedPreferencesService.saveGroupId(userLogin.groupId!);
          }

          if (userLogin.roomId != null) {
            await SharedPreferencesService.saveRoomid(userLogin.roomId!);
          }

          return userLogin;
        } else {
          throw Exception('Login failed: ${response.data}');
        }
      } else {
        // Jika status code bukan 200, kita cek apakah ada pesan error dari backend
        final errorData = response.data;
        if (errorData != null) {
          final errorMessage =
              (errorData['errors'] as List?)?.isNotEmpty == true
                  ? errorData['errors'][0]['msg']
                  : 'Login gagal';

          throw Exception(errorMessage);
        }

        throw Exception(
          'Login gagal dengan status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      if (e.response != null) {
        final errorData = e.response?.data;
        if (errorData != null && errorData is Map<String, dynamic>) {
          final errorMessage =
              (errorData['errors'] as List?)?.isNotEmpty == true
                  ? errorData['errors'][0]['msg']
                  : 'Login gagal';

          throw Exception(errorMessage);
        }
      }
      throw Exception('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  /// Fungsi untuk logout dari API dan menghapus data pengguna
  Future<void> logoutFromAPI() async {
    const url = Endpoints.baseUrl2 + Endpoints.logoutUrl;
    final token = await SharedPreferencesService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'token': token,
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Berhasil logout dari API');

        // Hapus semua data di SharedPreferences
        await SharedPreferencesService.clearAllSharedPreferences();

        // Hapus semua interceptor Dio
        _dio.interceptors.clear();

        // Menutup semua controller GetX
        await Get.deleteAll();
      } else {
        print('Gagal logout dari API: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while logging out from API: $e');
    }
  }

  /// Fungsi untuk logout dari akun Google
  Future<void> logoutFromGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      // Disconnect akun Google untuk menghapus cache login
      await googleSignIn.disconnect();

      // Sign out dari Google
      await googleSignIn.signOut();

      // Hapus token Google dari penyimpanan lokal
      await SharedPreferencesService.clearTokenGoogle();

      print('Berhasil logout dari Google. Pengguna perlu memilih akun lagi.');
    } catch (e) {
      print('Terjadi kesalahan saat logout dari Google: $e');
    }
  }
}
