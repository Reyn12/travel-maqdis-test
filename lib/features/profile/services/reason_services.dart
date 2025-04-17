import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';
import 'package:maqdis_connect/features/profile/models/reason_model.dart';

class ReasonService {
  final Dio _dio = Dio(BaseOptions(baseUrl: '${Endpoints.baseUrl2}/api'));

  Future<List<ReasonModel>> fetchReasons() async {
    try {
      final response = await _dio.get('/profile/reason');

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('response reason: $responseData');
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data')) {
          List<ReasonModel> reasons = (responseData['data'] as List)
              .map((json) => ReasonModel.fromJson(json))
              .toList();
          reasons.add(ReasonModel(reasonId: '999', reason: 'Lainnya'));

          return reasons;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load reasons');
      }
    } catch (e) {
      throw Exception('Error fetching reasons: $e');
    }
  }
}
