import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';
import 'package:maqdis_connect/features/doa/models/video_doa_model.dart';

class VideoDoaService {
  final Dio _dio = Dio(BaseOptions(baseUrl: '${Endpoints.baseUrl2}/api'));

  /// fungsi get seluruh video dari api
  Future<List<VideoDoaModel>?> getVideoDoa() async {
    try {
      final response = await _dio.get('/Videos');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        // Pastikan data yang diterima adalah List
        if (data is List) {
          return data.map((video) => VideoDoaModel.fromJson(video)).toList();
        } else {
          print('Error: Data yang diterima bukan List. Cek API Response.');
          return null;
        }
      } else {
        print('Error ${response.statusCode}: Gagal mengambil data video.');
        return null;
      }
    } catch (e) {
      print('Exception: ${e.toString()}');
      return null;
    }
  }

  /// fungsi get video by id dari api
  Future<VideoDoaModel?> getVideoById(String videoid) async {
    try {
      final response = await _dio.get('/Videos/$videoid');

      if (response.statusCode == 200 && response.data != null) {
        return VideoDoaModel.fromJson(response.data);
      } else {
        print('Error ${response.statusCode}: Video tidak ditemukan.');
        return null;
      }
    } catch (e) {
      print('Exception: ${e.toString()}');
      return null;
    }
  }
}
