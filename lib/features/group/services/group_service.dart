import 'package:dio/dio.dart';
import 'package:maqdis_connect/core/services/endpoints.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/group/models/check_group_model.dart';
import 'package:maqdis_connect/features/group/models/check_user_group_model.dart';
import 'package:maqdis_connect/features/group/models/check_user_in_group.dart';
import 'package:maqdis_connect/features/group/models/generate_room_code.dart';
import 'package:maqdis_connect/features/group/models/get_list_group_model.dart';

class GroupService {
  final Dio _dio = Dio(
    BaseOptions(
      followRedirects: true,
      validateStatus: (status) {
        return status! < 500; // Accept status codes <500
      },
    ),
  );

  Future<CheckUserGroupModel?> getCekUserGrup() async {
    final idUser = await SharedPreferencesService.getIdUser();
    final idGrup = await SharedPreferencesService.getGroupId();

    if (idGrup == null || idGrup.isEmpty || idUser == null || idUser.isEmpty) {
      print('Data userId atau grupId tidak ditemukan');
      return null;
    }

    try {
      final response = await Dio().get(
        Endpoints.baseUrl2 + Endpoints.cekUserGrup,
        queryParameters: {
          'userId': idUser,
          'grupid': idGrup,
        },
      );

      if (response.statusCode == 200) {
        return CheckUserGroupModel.fromJson(response.data);
      } else {
        print('Response Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      return null;
    }
  }

  Future<List<GroupModel>?> getGrup() async {
    print('getGrup() dipanggil.');
    const url = Endpoints.baseUrl2 + Endpoints.getGrup;

    try {
      final response = await _dio.get(url);
      print('Response status: ${response.statusCode}');
      print('Response data(GroupService): ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        // Pastikan data adalah List<dynamic>
        if (data is List) {
          final List<GroupModel> grupList =
              data.map((grup) => GroupModel.fromJson(grup)).toList();
          return grupList;
        } else {
          print('Data yang diterima bukan List: $data');
          return null;
        }
      } else {
        print('Gagal mengambil data grup: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Kesalahan pada getGrup(): $e');
      return null;
    }
  }

  Future<CheckUserInGroupResponse> fetchGroupUsers() async {
    try {
      // Get grupid from shared preferences
      final grupid = await SharedPreferencesService.getGroupId();
      if (grupid == null || grupid.isEmpty) {
        throw Exception('Group ID is missing or empty');
      }
      print('Fetching users for group ID: $grupid');

      // Call the API with query parameters
      final response = await _dio.get(
        Endpoints.baseUrl2 + Endpoints.getPesertaGroup,
        data: {'grupid': grupid}, // Gunakan queryParameters untuk GET
      );

      // Debugging: log response data
      print('Response Data Peserta: ${response.data}');

      // Pastikan response dalam bentuk Map dan memiliki 'data' serta 'roomId'
      if (response.data is Map && response.data['data'] is List) {
        return CheckUserInGroupResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Invalid API response format: Expected a list in "data"');
      }
    } catch (e) {
      print('Error fetching group users: $e');
      rethrow; // Lempar ulang error agar bisa ditangani di UI
    }
  }

  Future<List<CheckUserInGroupModel>> fetchGroupUsersByGroupId(
      String groupId) async {
    try {
      if (groupId.isEmpty) {
        throw Exception('Group ID is missing or empty');
      }

      // Call the API with query parameters
      final response = await _dio.get(
        Endpoints.baseUrl2 + Endpoints.getPesertaGroup,
        data: {'grupid': groupId},
      );

      // Debugging: log response data
      print('Response Data Peserta: ${response.data}');

      // Ensure that the response contains a 'data' field with a list
      if (response.data is Map && response.data['data'] is List) {
        final users = (response.data['data'] as List)
            .map((data) =>
                CheckUserInGroupModel.fromJson(data as Map<String, dynamic>))
            .toList();
        return users;
      } else {
        throw Exception('Expected a list in the response data');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Jika error 404, kembalikan daftar kosong
        print('Group not found (404), returning empty list');
        return [];
      } else {
        print('Error fetching group users by group id: $e');
        rethrow;
      }
    } catch (e) {
      print('Error fetching group users by group id: $e');
      rethrow;
    }
  }

  Future<bool> joinGrup(String grupId) async {
    try {
      // Mendapatkan token dan userId
      final token = await SharedPreferencesService.getToken();
      final userId = await SharedPreferencesService.getIdUser();

      if (token == null || userId == null) {
        print('Token atau User ID tidak ditemukan.');
        return false;
      }

      const url = '${Endpoints.baseUrl2}api/Group/join';

      // Request ke API
      final response = await _dio.post(
        url,
        options: Options(
          headers: {'token': token},
        ),
        queryParameters: {'userId': userId},
        data: {'grupid': grupId},
      );

      // Debugging: log response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');

      if (response.statusCode == 200) {
        print('Berhasil bergabung dengan grup.');
        return true;
      } else {
        print('Gagal bergabung dengan grup. Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error saat bergabung dengan grup: $e');
      return false;
    }
  }

  Future<RoomCodeModel> fetchRoomCode() async {
    final token = await SharedPreferencesService.getToken();
    final roomId = await SharedPreferencesService.getRoomid();

    if (token == null && roomId == null) {
      throw Exception('Token dan roomId tidak ditemukan');
    }
    const url = '${Endpoints.baseUrl2}api/Audio/generateRoomCode';

    final response = await _dio.post(
      url,
      options: Options(
        headers: {'token': token},
      ),
      data: {"roomid": roomId},
    );

    if (response.statusCode == 200) {
      final data = response.data;
      return RoomCodeModel.fromJson(data['data']);
    } else {
      throw Exception("Failed to fetch room code");
    }
  }

  Future<bool> exitGrup() async {
    try {
      // Ambil token dan userId dari SharedPreferences
      final token = await SharedPreferencesService.getToken();
      final userId = await SharedPreferencesService.getIdUser();
      final grupId = await SharedPreferencesService.getGroupId();
      print('keluar dari grup id : $grupId');
      if (token == null || userId == null) {
        print('Token atau User ID tidak ditemukan.');
        return false; // Gagal karena token atau userId tidak valid
      }

      const url = '${Endpoints.baseUrl2}api/Group/exit';

      // Melakukan request POST menggunakan Dio
      final response = await _dio.post(
        url,
        options: Options(
          headers: {'token': token}, // Header dengan token
        ),
        queryParameters: {
          'userId': userId, // Query parameter dengan userId
        },
        data: {
          'grupid': grupId, // Body dengan grupId
        },
      );

      if (response.statusCode == 200) {
        print('Berhasil keluar dari grup.');
        // hapus grupid dari shared preferences
        await SharedPreferencesService.clearGroupId();
        await SharedPreferencesService.clearGroupName();
        await SharedPreferencesService.clearRoomid();
        return true; // Berhasil keluar
      } else {
        print('Gagal keluar dari grup. Status: ${response.statusCode}');
        print('Pesan dari API: ${response.data}');
        return false; // Gagal keluar
      }
    } catch (e) {
      print('Error saat keluar dari grup: $e');
      return false; // Gagal karena terjadi error
    }
  }

  Future<bool> setStatusOnline() async {
    try {
      // Ambil grupId dan userId dari SharedPreferences
      final token = await SharedPreferencesService.getToken();
      final grupId = await SharedPreferencesService.getGroupId();
      final userId = await SharedPreferencesService.getIdUser();

      if (grupId == null || userId == null) {
        print('Grup ID atau User ID tidak ditemukan.');
        return false; // Gagal karena grupId atau userId tidak valid
      }

      const url = '${Endpoints.baseUrl2}api/setStatus/Online';

      // Kirim request POST ke API
      final response = await _dio.post(
        url,
        options: Options(
          headers: {'token': token}, // Header dengan token
        ),
        data: {
          'grupid': grupId,
          'userId': userId,
        },
      );

      if (response.statusCode == 200) {
        print('Berhasil mengatur status ke Online.');
        return true; // Berhasil
      } else {
        print(
          'Gagal mengatur status ke Online. Status: ${response.statusCode}',
        );
        return false; // Gagal
      }
    } catch (e) {
      print('Error saat mengatur status ke Online: $e');
      return false; // Gagal karena terjadi error
    }
  }

  Future<bool> setStatusOffline() async {
    try {
      // Ambil grupId dan userId dari SharedPreferences
      final token = await SharedPreferencesService.getToken();
      final grupId = await SharedPreferencesService.getGroupId();
      final userId = await SharedPreferencesService.getIdUser();

      if (grupId == null || userId == null) {
        print('Grup ID atau User ID tidak ditemukan.');
        return false; // Gagal karena grupId atau userId tidak valid
      }

      const url = '${Endpoints.baseUrl2}api/setStatus/Offline';

      // Kirim request POST ke API
      final response = await _dio.post(
        url,
        options: Options(
          headers: {'token': token}, // Header dengan token
        ),
        data: {
          'grupid': grupId,
          'userId': userId,
        },
      );

      if (response.statusCode == 200) {
        print('Berhasil mengatur status ke Offline.');
        return true; // Berhasil
      } else {
        print(
          'Gagal mengatur status ke Offline. Status: ${response.statusCode}',
        );
        return false; // Gagal
      }
    } catch (e) {
      print('Error saat mengatur status ke Offline: $e');
      return false; // Gagal karena terjadi error
    }
  }

  // // Method to fetch group list
  Future<List<GroupListModel>> getListGroup() async {
    try {
      final response =
          await _dio.get(Endpoints.baseUrl2 + Endpoints.getListGrup);

      if (response.statusCode == 200) {
        final data = response.data; // response.data langsung berupa List
        print('Respon API GetListGrup: $data');

        if (data is List) {
          // Pastikan setiap elemen adalah Map
          return data
              .map(
                (group) =>
                    GroupListModel.fromJson(group as Map<String, dynamic>),
              )
              .toList();
        } else {
          throw Exception('API response is not a List');
        }
      } else {
        throw Exception('Failed to load groups');
      }
    } catch (e) {
      print('Error in getListGroup: $e');
      rethrow;
    }
  }
}
