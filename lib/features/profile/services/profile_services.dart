import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/profile/models/user_profile_model.dart';

class ProfileServices {
  final Dio _dio = Dio(BaseOptions(
    followRedirects: true,
    validateStatus: (status) {
      return status! < 500; // Accept status codes <500
    },
  ));

  Future<Map<String, dynamic>?> getProfile() async {
    const String url = Endpoints.baseUrl2 + Endpoints.getProfileUrl;
    String? token = await SharedPreferencesService.getToken();
    print('Token yang dikirim: $token');

    if (token!.isEmpty) {
      print('Token tidak ditemukan di SharedPreferences');
      throw Exception('Token tidak ditemukan');
    }

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'token': token, // Pass the token directly as a custom header
          },
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return response.data; // Return profile data if successful
      } else {
        print('Gagal mengambil profil: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      return null;
    }
  }

  Future<UserProfileModel?> updateProfile(String name, String whatsapp) async {
    String? token = await SharedPreferencesService.getToken();
    try {
      final data = {
        'name': name,
        'whatsapp': whatsapp,
      };

      // Configure Dio with validateStatus
      Response response = await _dio.put(
        Endpoints.baseUrl2 + Endpoints.updateProfileUrl,
        data: data,
        options: Options(
          headers: {
            'token': token, // Sending the token in the header
          },
          validateStatus: (status) {
            // Accepts all status codes except 500
            return status != null && status < 500;
          },
        ),
      );

      // Debugging response
      print('Response Status: ${response.statusCode}');
      // print('Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final updatedProfile = UserProfileModel.fromJson(response.data['data']);
        return updatedProfile;
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
