import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCheckingService {
  Future<bool> checkTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // ini token dari api backend
    try {
      final response = await Dio().get(
        Endpoints.baseUrl2 + Endpoints.checkToken,
        options: Options(
          headers: {
            'token': token,
          },
        ),
      );

      if (response.statusCode == 200 &&
          response.data['msg'] == 'Access to protected route granted') {
        return true; // Token is valid
      }
      return false; // Token is invalid
    } catch (e) {
      print('Error validating token: $e');
      return false; // Assume token is invalid if an error occurs
    }
  }
}
