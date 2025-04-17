import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';

class PlayerService {
  final dio = Dio();

  Future<List<dynamic>> fetchDoaByPerjalananId(String perjalananId) async {
    try {
      final response = await dio
          .get('${Endpoints.baseUrl2}api/Doa/perjalanan/$perjalananId');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error loading API data: $e");
    }
  }
}
