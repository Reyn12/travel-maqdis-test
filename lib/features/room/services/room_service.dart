import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/room/models/room_model.dart';
import 'package:maqdis_connect/features/room/services/local/room_data.dart';

class RoomServices {
  final Dio _dio = Dio(
    BaseOptions(
      followRedirects: true,
      validateStatus: (status) {
        return status! < 500; // Accept status codes <500
      },
    ),
  );

  Future<void> refreshAndSaveTokenSpeaker() async {
    try {
      final token = await SharedPreferencesService.getToken();
      final roomId = await SharedPreferencesService.getRoomid();

      if (roomId == null || token == null) {
        print('Room ID or Token is null.');
        throw Exception('Room ID or Token is null.');
      }

      print('Token: $token');
      print('Room ID: $roomId');

      final response = await _dio.post(
        Endpoints.baseUrl2 + Endpoints.urlRoomRefresh,
        options: Options(
          headers: {'token': token},
        ),
        data: {'room_Id': roomId},
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['room'] != null) {
          final tokenSpeaker = data['room']['token_speaker'];
          if (tokenSpeaker != null) {
            await SharedPreferencesService.saveTokenSpeaker(
                tokenSpeaker as String);
            print('Token Speaker berhasil disimpan: $tokenSpeaker');
          } else {
            throw Exception('Token speaker tidak ditemukan di respons API');
          }
        } else {
          throw Exception('Data room tidak valid dalam respons API');
        }
      } else if (response.statusCode == 500) {
        throw Exception('Server error: ${response.data}');
      } else {
        throw Exception('API gagal dengan status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      throw Exception('Gagal menyimpan token speaker: $e');
    }
  }

  Future<RoomModelResponse> getRoomById() async {
    final token = await SharedPreferencesService.getToken();
    final roomId = await SharedPreferencesService.getRoomid();

    if (token == null || roomId == null) {
      throw Exception('Token atau Room ID tidak ditemukan.');
    }

    try {
      final response = await _dio.get(
        '${Endpoints.baseUrl2}api/Audio/getRoomById',
        options: Options(
          headers: {
            'token': token,
          },
        ),
        data: {
          'room_Id': roomId,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = response.data as Map<String, dynamic>;
        final roomResponse = RoomModelResponse.fromJson(jsonData);

        // Simpan token_speaker dan token_listener ke SharedPreferences
        await RoomDataSharedPreferenceService.saveTokenSpeakerUser(
          roomResponse.room.tokenSpeaker,
        );
        await RoomDataSharedPreferenceService.saveTokenListener(
          roomResponse.room.tokenListener,
        );

        print('Token Speaker dan Listener berhasil disimpan');
        return roomResponse;
      } else {
        throw Exception('Error: ${response.statusCode}, ${response.data}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      throw Exception('Terjadi kesalahan saat memuat data: $e');
    }
  }
}
