import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/beranda/models/perjalanan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerjalananService {
  final Dio _dio = Dio();

  Future<List<PerjalananModel>> getPerjalanan() async {
    try {
      // Endpoint GET perjalanan
      final response = await _dio.get('${Endpoints.baseUrl2}api/perjalanan');

      // Check if response is successful
      if (response.statusCode == 200 && response.data['data'] != null) {
        // Parse and map the response data to the Perjalanan model
        List<PerjalananModel> perjalananModels = (response.data['data'] as List)
            .map((data) => PerjalananModel.fromJson(data))
            .toList();

        // Loop through each perjalanan and save based on kategori
        for (var perjalanan in perjalananModels) {
          if (perjalanan.namaPerjalanan != null) {
            if (perjalanan.namaPerjalanan!.contains('Manasik')) {
              await SharedPreferencesService.savePerjalananManasik(
                perjalanan.perjalananId,
                perjalanan.namaPerjalanan ?? 'Unnamed Trip',
              );
              // print('Saved Manasik: ${perjalanan.namaPerjalanan}');
            } else if (perjalanan.namaPerjalanan!.contains('Umroh')) {
              await SharedPreferencesService.savePerjalananUmroh(
                perjalanan.perjalananId,
                perjalanan.namaPerjalanan ?? 'Unnamed Trip',
              );
              // print('Saved Umroh: ${perjalanan.namaPerjalanan}');
            } else if (perjalanan.namaPerjalanan!.contains('Towafwada')) {
              await SharedPreferencesService.savePerjalananTowafwada(
                perjalanan.perjalananId,
                perjalanan.namaPerjalanan ?? 'Unnamed Trip',
              );
              // print('Saved Towafwada: ${perjalanan.namaPerjalanan}');
            }
          }
        }

        return perjalananModels;
      } else {
        throw Exception('Failed to load perjalanan data');
      }
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        throw Exception(
            'Server error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      } else {
        throw Exception('Connection failed: ${e.message}');
      }
    }
  }

  Future<Map<String, bool>> fetchPerjalananStatuses() async {
    final prefs = await SharedPreferences.getInstance();

    // Fetching status for each perjalanan as boolean
    final manasikStatus = prefs.getString('manasik_status') == 'true';
    final umrohStatus = prefs.getString('umroh_status') == 'true';
    final towafwadaStatus = prefs.getString('tawafwada_status') == 'true';

    // Debugging: Print fetched status
    print(
        "Fetched Manasik: $manasikStatus, Umroh: $umrohStatus, Tawaf Wada: $towafwadaStatus");

    return {
      'manasik': manasikStatus,
      'umroh': umrohStatus,
      'tawaf wada': towafwadaStatus,
    };
  }

  Future<Map<String, dynamic>> postProgress(String perjalananId) async {
    const String url = '${Endpoints.baseUrl2}api/progress';

    String? token = await SharedPreferencesService.getToken();
    print('token saat ini: $token');
    String? grupId = await SharedPreferencesService.getGroupId();
    print('grupID local storage saat ini: $grupId');

    if (token == null || token.isEmpty || grupId == null || grupId.isEmpty) {
      throw Exception('Token atau grupId tidak ditemukan');
    }

    try {
      Map<String, dynamic> body = {
        'grupid': grupId,
        'perjalananid': perjalananId,
      };

      final response = await _dio.post(
        url,
        data: body,
        options: Options(
          headers: {'token': token},
        ),
      );

      if (response.statusCode == 200) {
        return response.data; // Return response data
      } else {
        throw Exception('Gagal mengirim progress: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Terjadi kesalahan: $e');
      if (e.response?.statusCode == 404) {
        throw Exception('Endpoint tidak ditemukan (404)');
      } else {
        throw Exception('Error saat mengirim progress: ${e.message}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      throw Exception('Error saat mengirim progress');
    }
  }
}
