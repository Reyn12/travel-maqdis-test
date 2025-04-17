import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';

class OtpService {
  static const String baseUrl = '${Endpoints.baseUrl2}/api/';
  static final Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {"Content-Type": "application/json"},
  ));

  // Request OTP
  static Future<Map<String, dynamic>> requestOtp(
      String email, String type) async {
    try {
      final response = await dio.post(
        "email/request-otp",
        data: {"email": email, "type": type},
      );
      print('reset email: ${response.data}');
      return response.data;
    } catch (e) {
      return {"message": "Gagal request OTP"};
    }
  }

  // Verifikasi OTP
  static Future<Map<String, dynamic>> verifyOtp(
      String email, String otp) async {
    try {
      final response = await dio.post(
        "email/verify-otp",
        data: {"email": email, "otp": otp},
      );
      return response.data;
    } catch (e) {
      return {"message": "Gagal verifikasi OTP"};
    }
  }

  // reset password
  static Future<Map<String, dynamic>> resetPassword(
      String email, String newPassword) async {
    try {
      final response = await dio.post(
        "auth/reset-password",
        data: {"email": email, "newPassword": newPassword},
      );
      return response.data;
    } catch (e) {
      return {"message": "Gagal reset password"};
    }
  }
}
