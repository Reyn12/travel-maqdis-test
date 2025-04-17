// ignore_for_file: file_names, unused_local_variable
import 'package:maqdis_connect/features/auth/models/local/shared_preferences_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<void> simpanData(
      String idUser,
      String name,
      String email,
      String nowa,
      String createdAt,
      String role,
      String token,
      String lastLogin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('id', idUser);
    await pref.setString('name', name);
    await pref.setString('email', email);
    await pref.setString('whatsapp', nowa);
    await pref.setString('createdAt', createdAt);
    await pref.setString('role', role);
    await pref.setString('token', token);
    await pref.setString('lastLogin', lastLogin);
  }

  static Future<SharedPreferencesModel> getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String iduser = pref.getString('id') ?? '';
    String username = pref.getString('username') ?? '';
    String email = pref.getString('email') ?? '';
    String nowa = pref.getString('whatsapp') ?? '';
    String photo = pref.getString('photo') ?? '';
    String createdAt = pref.getString('createdAt') ?? '';
    String role = pref.getString('role') ?? '';
    String apitoken = pref.getString('token') ?? '';
    String lastLogin = pref.getString('lastLogin') ?? '';

    return SharedPreferencesModel(
      iduser: iduser,
      username: username,
      email: email,
      nowa: nowa,
      photo: photo,
      createdAt: createdAt,
      token: apitoken,
      lastLogin: lastLogin,
      role: role,
    );
  }

  static Future<void> clearUser() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('id');
    await pref.remove('name');
    await pref.remove('email');
    await pref.remove('whatsapp');
    await pref.remove('createdAt');
    await pref.remove('role');
    await pref.remove('lastLogin');
  }

  static Future<void> saveLoginType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_type', type); // Save login type
  }

  static Future<String?> getLoginType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('login_type'); // Retrieve login type
  }

  static Future<void> clearLoginType() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('login_type'); // Clear login type
  }

  static Future<void> simpanToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<void> simpanTokenGoogle(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tokenGoogle', token);
  }

  static Future<String?> getTokenGoogle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tokenGoogle');
  }

  static Future<void> clearTokenGoogle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tokenGoogle');
  }

  static Future<void> saveIdRoleUser(String iduser, String username,
      String role, String photo, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', iduser); // Save login type
    await prefs.setString('username', username);
    await prefs.setString('role', role);
    await prefs.setString('photo', photo);
    await prefs.setString('email', email);
  }

  static Future<String?> getIdRoleUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs
      ..getString('id') // Retrieve login type
      ..getString('username')
      ..getString('role');
    return null;
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role'); // Retrieve login type
  }

  static Future<String?> getIdUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id'); // Retrieve login type
  }

  static Future<String?> getEmailUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email'); // Retrieve login type
  }

  static Future<void> clearIdRoleUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id'); // Clear login type
    await prefs.remove('role');
  }

  static Future<void> saveGrupData(
    String grupId,
    String grupName,
    String grupCreatedBy,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('grupid', grupId); // Save login type
    // await prefs.setString('nama_grup', grupName);
    await prefs.setString('created_by', grupCreatedBy);

    // Log data yang diambil dari SharedPreferences
    print('Data grup dari SharedPreferences:');
    print('grupid: $grupId');
    // print("nama_grup: $grupName");
    print('created_by: $grupCreatedBy');
  }

  static Future<void> setNamaGrup(String namaGrup) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nama_grup', namaGrup);
  }

  static Future<void> clearGrupData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('grupid'); // Clear login type
    await prefs.remove('nama_grup');
    await prefs.remove('created_by');
  }

  static Future<void> getGrupData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString('grupid'); // Retrieve login type
    prefs.getString('nama_grup');
    prefs.getString('created_by');
  }

  static Future<String?> getGrupId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString('grupid');
    return null;
  }

  static Future<void> saveGroupId(String groupId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('groupId', groupId);
  }

  static Future<void> saveGroupName(String groupName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('groupName', groupName);
  }

  static Future<String?> getGroupName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('groupName');
  }

  static Future<void> clearGroupName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('groupName');
  }

  static Future<String?> getGroupId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('groupId');
  }

  static Future<void> clearGroupId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('groupId');
  }

  static Future<void> savePerjalananManasik(
    String perjalananId,
    String namaPerjalanan,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('manasik_perjalananId', perjalananId);
    await prefs.setString('manasik_nama_perjalanan', namaPerjalanan);
  }

  // Save Umroh
  static Future<void> savePerjalananUmroh(
    String perjalananId,
    String namaPerjalanan,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('umroh_perjalananId', perjalananId);
    await prefs.setString('umroh_nama_perjalanan', namaPerjalanan);
  }

  // Save Towaf Wada
  static Future<void> savePerjalananTowafwada(
    String perjalananId,
    String namaPerjalanan,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('towafwada_perjalananId', perjalananId);
    await prefs.setString('towafwada_nama_perjalanan', namaPerjalanan);
  }

  // Get Manasik
  static Future<Map<String, String?>> getPerjalananManasik() async {
    final prefs = await SharedPreferences.getInstance();
    final perjalananId = prefs.getString('manasik_perjalananId');
    final namaPerjalanan = prefs.getString('manasik_nama_perjalanan');
    return {'perjalananId': perjalananId, 'nama_perjalanan': namaPerjalanan};
  }

  // Get Umroh
  static Future<Map<String, String?>> getPerjalananUmroh() async {
    final prefs = await SharedPreferences.getInstance();
    final perjalananId = prefs.getString('umroh_perjalananId');
    final namaPerjalanan = prefs.getString('umroh_nama_perjalanan');
    return {'perjalananId': perjalananId, 'nama_perjalanan': namaPerjalanan};
  }

  // Get Towaf Wada
  static Future<Map<String, String?>> getPerjalananTowafwada() async {
    final prefs = await SharedPreferences.getInstance();
    final perjalananId = prefs.getString('towafwada_perjalananId');
    final namaPerjalanan = prefs.getString('towafwada_nama_perjalanan');
    return {'perjalananId': perjalananId, 'nama_perjalanan': namaPerjalanan};
  }

  // Clear Manasik
  static Future<void> clearPerjalananManasik() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('manasik_perjalananId');
    await prefs.remove('manasik_nama_perjalanan');
  }

  // Clear Umroh
  static Future<void> clearPerjalananUmroh() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('umroh_perjalananId');
    await prefs.remove('umroh_nama_perjalanan');
  }

  // Clear Towaf Wada
  static Future<void> clearPerjalananTowafwada() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('towafwada_perjalananId');
    await prefs.remove('towafwada_nama_perjalanan');
  }

  static Future<void> clearAllSharedPreferences() async {
    // Mendapatkan instance dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Menghapus semua data dari SharedPreferences
    await prefs.clear();

    print('All data cleared from SharedPreferences.');
  }

  static Future<void> saveRoomid(String roomId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('roomid', roomId);
    print('Room ID saved: $roomId');
  }

  static Future<String?> getRoomid() async {
    final prefs = await SharedPreferences.getInstance();
    final roomId = prefs.getString('roomid');
    print('Fetched Room ID: $roomId');
    return roomId; // Mengembalikan nilai yang tersimpan
  }

  static Future<void> clearRoomid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('roomid'); // Hapus roomid dari SharedPreferences
    print('Room ID cleared');
  }

// Menyimpan token ke SharedPreferences
  static Future<void> saveTokenSpeaker(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token_speaker', token);
    print('Saved Token Speaker: $token');
  }

  static Future<void> saveTokenListener(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token_listener', token);
    print('Saved Token Speaker: $token');
  }
}
