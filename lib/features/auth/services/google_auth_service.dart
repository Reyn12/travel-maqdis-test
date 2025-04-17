import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';
import 'package:maqdis_connect/features/auth/models/login_model.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';

class GoogleAuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl2));

  // logic login with google yang hit langsung ke backend
  Future<LoginModel?> loginWithGoogle(String idToken) async {
    print('idTokenService : $idToken');
    try {
      final response = await _dio.post(
        Endpoints.loginGoogle,
        data: {"idToken": idToken},
      );
      print('Response dari backend Google Sign-In: ${response.data}');

      if (response.statusCode == 200) {
        print('Response dari backend Google Sign-In: ${response.data}');

        final userLogin = LoginModel.fromJson(response.data);

        print('haha test: ${userLogin.token}');

        if (userLogin.status == 'success') {
          // Simpan token, ID, role, dan grupid jika ada
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

          print(
              'Login Google sukses! ID: ${userLogin.id}, Role: ${userLogin.role}, Grup ID: ${userLogin.groupId}');
          return userLogin;
        } else {
          print('Login Google gagal: ${response.data}');
          return null;
        }
      } else {
        print('Login Google gagal, status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print("Error Google Sign-Ins: $e");
      return null;
    }
  }
}
