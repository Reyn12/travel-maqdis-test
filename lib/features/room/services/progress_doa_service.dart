import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';

class ProgressDoaService {
  final Dio _dio = Dio(BaseOptions(baseUrl: '${Endpoints.baseUrl2}/api'));

  Future<List<dynamic>> fetchDoaByPerjalananId(String perjalananId) async {
    try {
      final response = await _dio.get('/Doa/perjalanan/$perjalananId');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error loading API data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchDoaTitlesByPerjalananId(
      String perjalananId, String progressId) async {
    print('ini perjalanan id: $perjalananId');
    print('ini progressid: $progressId');
    try {
      final response =
          await _dio.get('/Doa/status-doa/$perjalananId/$progressId');

      if (response.statusCode == 200) {
        print("Response status: ${response.statusCode}");
        print("Response data: ${response.data}");

        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception("Error: \${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error loading API data: \$e");
    }
  }

  Future<Map<String, dynamic>> postProgressDoa(
      String progressId, String doaId) async {
    print(
        'post progress doa dengan progressId: $progressId, dan doaId: $doaId');
    try {
      Response response = await _dio.post('/progressDoa', data: {
        "progressid": progressId,
        "doaid": doaId,
      });
      return response.data;
    } catch (e) {
      print('Failed to post progress doa: $e');
      throw Exception('Failed to post progress doa: $e');
    }
  }

  Future<Map<String, dynamic>> updateProgressDoa(String progressDoaId) async {
    try {
      final response = await _dio.put('/progressDoa/$progressDoaId');
      return response.data;
    } catch (e) {
      throw Exception('Failed to update progress doa: $e');
    }
  }
}
