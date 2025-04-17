import 'package:shared_preferences/shared_preferences.dart';

class RoomDataSharedPreferenceService {
  static Future<String?> getTokenSpeaker() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenSpeaker = prefs.getString('token_speaker');
    print('Fetched Token Speaker: $tokenSpeaker');
    return tokenSpeaker;
  }

  // clear roomid
  static Future<void> clearTokenSpeaker() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token_speaker'); // Clear login type
  }

  // Menyimpan token ke SharedPreferences
  static Future<void> saveTokenSpeakerUser(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token_speaker', token);
    print('Saved Token Speaker: $token');
  }

  static Future<String?> getTokenSpeakerUser() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenSpeakerUser = prefs.getString('token_speaker');
    print('Fetched Token Speaker: $tokenSpeakerUser');
    return tokenSpeakerUser;
  }

  // clear roomid
  static Future<void> clearTokenSpeakerUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token_speaker'); // Clear login type
  }

  static Future<void> saveTokenListener(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token_listener', token);
    print('Saved Token Speaker: $token');
  }

  static Future<String?> getTokenListener() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenListener = prefs.getString('token_listener');
    print('Fetched Token Speaker: $tokenListener');
    return tokenListener;
  }

  // clear roomid
  static Future<void> clearTokenListener() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token_listener'); // Clear login type
  }

  // Fungsi untuk menyimpan progress ID
  // Fungsi untuk menyimpan progress ID
  static Future<void> saveProgressPerjalananId(String idProgress) async {
    final prefs = await SharedPreferences.getInstance();
    final storedId =
        prefs.getString('id_progress'); // Ambil id_progress yang sudah ada

    // Cek apakah id_progress yang disimpan sudah ada dan sama dengan yang baru
    if (storedId != idProgress) {
      print('Menyimpan id_progress baru: $idProgress');

      // Hapus id_progress yang lama sebelum menyimpan yang baru
      await prefs.remove('id_progress');

      // Simpan id_progress yang baru
      await prefs.setString('id_progress', idProgress);
    } else {
      print(
          'id_progress sudah ada di SharedPreferences, tidak perlu menyimpan ulang.');
    }
  }

// Fungsi untuk mengambil progress ID
  static Future<String?> getProgressPerjalananId() async {
    final prefs = await SharedPreferences.getInstance();
    final idProgress = prefs.getString('id_progress');
    print('Mengambil id_progress dari SharedPreferences: $idProgress');
    return idProgress;
  }

// Fungsi untuk menghapus progress ID
  static Future<void> clearProgressPerjalananId() async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.remove('id_progress');
    print('Menghapus id_progress, success: $success');
  }

  static Future<void> saveCurrentPerjalananId(String idPerjalanan) async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setString('id_perjalanan', idPerjalanan);
    print('Menyimpan id perjalanan, success: $success');
  }

  static Future<String?> getCurrentPerjalananId() async {
    final prefs = await SharedPreferences.getInstance();
    final success = prefs.getString('id_perjalanan');
    print('Mengambil id perjalanan, success: $success');
    return success;
  }

  static Future<void> clearCurrentPerjalananId() async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.remove('id_perjalanan');
    print('Menghapus id perjalanan, success: $success');
  }

//   // Save Manasik
//   static Future<void> saveManasik(
//       String jenisPerjalanan, String isFinished) async {
//     final prefs = await SharedPreferences.getInstance();

//     // Periksa apakah data sudah ada
//     final existingJenisPerjalanan = prefs.getString('manasik_jenis_perjalanan');
//     final existingStatus = prefs.getString('manasik_status');

//     if (existingJenisPerjalanan == jenisPerjalanan &&
//         existingStatus == isFinished) {
//       print('Data Manasik sudah ada, tidak perlu disimpan ulang.');
//       return;
//     }

//     // Simpan jika data belum ada atau berbeda
//     await prefs.setString('manasik_jenis_perjalanan', jenisPerjalanan);
//     await prefs.setString('manasik_status', isFinished);
//     print(
//         'Data Manasik disimpan: jenis_perjalanan = $jenisPerjalanan, isFinished = $isFinished');
//   }

// // Save Umroh
//   static Future<void> saveUmroh(
//       String jenisPerjalanan, String isFinished) async {
//     final prefs = await SharedPreferences.getInstance();

//     // Periksa apakah data sudah ada
//     final existingJenisPerjalanan = prefs.getString('umroh_jenis_perjalanan');
//     final existingStatus = prefs.getString('umroh_status');

//     if (existingJenisPerjalanan == jenisPerjalanan &&
//         existingStatus == isFinished) {
//       print('Data Umroh sudah ada, tidak perlu disimpan ulang.');
//       return;
//     }

//     // Simpan jika data belum ada atau berbeda
//     await prefs.setString('umroh_jenis_perjalanan', jenisPerjalanan);
//     await prefs.setString('umroh_status', isFinished);
//     print(
//         'Data Umroh disimpan: jenis_perjalanan = $jenisPerjalanan, isFinished = $isFinished');
//   }

// // Save Towaf Wada
//   static Future<void> saveTowafwada(
//       String jenisPerjalanan, String isFinished) async {
//     final prefs = await SharedPreferences.getInstance();

//     // Periksa apakah data sudah ada
//     final existingJenisPerjalanan =
//         prefs.getString('tawafwada_jenis_perjalanan');
//     final existingStatus = prefs.getString('tawafwada_status');

//     if (existingJenisPerjalanan == jenisPerjalanan &&
//         existingStatus == isFinished) {
//       print('Data Towaf Wada sudah ada, tidak perlu disimpan ulang.');
//       return;
//     }

//     // Simpan jika data belum ada atau berbeda
//     await prefs.setString('tawafwada_jenis_perjalanan', jenisPerjalanan);
//     await prefs.setString('tawafwada_status', isFinished);
//     print(
//         'Data Tawaf Wada disimpan: jenis_perjalanan = $jenisPerjalanan, isFinished = $isFinished');
//   }

// Save Manasik
  static Future<void> saveManasik(
      String jenisPerjalanan, bool isFinished) async {
    final prefs = await SharedPreferences.getInstance();

    // Periksa apakah data sudah ada
    final existingJenisPerjalanan = prefs.getString('manasik_jenis_perjalanan');
    final existingStatus =
        prefs.getBool('manasik_isFinished'); // Menggunakan getBool

    if (existingJenisPerjalanan == jenisPerjalanan &&
        existingStatus == isFinished) {
      print('Data Manasik sudah ada, tidak perlu disimpan ulang.');
      return;
    }

    // Simpan jika data belum ada atau berbeda
    await prefs.setString('manasik_jenis_perjalanan', jenisPerjalanan);
    await prefs.setBool(
        'manasik_isFinished', isFinished); // Menyimpan sebagai bool
    print(
        'Data Manasik disimpan: jenis_perjalanan = $jenisPerjalanan, isFinished = $isFinished');
  }

// Save Umroh
  static Future<void> saveUmroh(String jenisPerjalanan, bool isFinished) async {
    final prefs = await SharedPreferences.getInstance();

    // Periksa apakah data sudah ada
    final existingJenisPerjalanan = prefs.getString('umroh_jenis_perjalanan');
    final existingStatus =
        prefs.getBool('umroh_isFinished'); // Menggunakan getBool

    if (existingJenisPerjalanan == jenisPerjalanan &&
        existingStatus == isFinished) {
      print('Data Umroh sudah ada, tidak perlu disimpan ulang.');
      return;
    }

    // Simpan jika data belum ada atau berbeda
    await prefs.setString('umroh_jenis_perjalanan', jenisPerjalanan);
    await prefs.setBool(
        'umroh_isFinished', isFinished); // Menyimpan sebagai bool
    print(
        'Data Umroh disimpan: jenis_perjalanan = $jenisPerjalanan, isFinished = $isFinished');
  }

// Save Towaf Wada
  static Future<void> saveTowafwada(
      String jenisPerjalanan, bool isFinished) async {
    final prefs = await SharedPreferences.getInstance();

    // Periksa apakah data sudah ada
    final existingJenisPerjalanan =
        prefs.getString('tawafwada_jenis_perjalanan');
    final existingStatus =
        prefs.getBool('tawafwada_isFinished'); // Menggunakan getBool

    if (existingJenisPerjalanan == jenisPerjalanan &&
        existingStatus == isFinished) {
      print('Data Towaf Wada sudah ada, tidak perlu disimpan ulang.');
      return;
    }

    // Simpan jika data belum ada atau berbeda
    await prefs.setString('tawafwada_jenis_perjalanan', jenisPerjalanan);
    await prefs.setBool(
        'tawafwada_isFinished', isFinished); // Menyimpan sebagai bool
    print(
        'Data Tawaf Wada disimpan: jenis_perjalanan = $jenisPerjalanan, isFinished = $isFinished');
  }

  // Get Manasik
  static Future<Map<String, String?>> getManasik() async {
    final prefs = await SharedPreferences.getInstance();

    final jenisPerjalanan = prefs.getString('manasik_jenis_perjalanan');
    final isFinished = prefs.getString('manasik_status');

    print(
        'Data Manasik didapatkan: jenis_perjalanan = $jenisPerjalanan, isFinished = $isFinished');

    return {
      'jenis_perjalanan': jenisPerjalanan,
      'isFinished': isFinished,
    };
  }

// Get Umroh
  static Future<Map<String, String?>> getUmroh() async {
    final prefs = await SharedPreferences.getInstance();

    final jenisPerjalanan = prefs.getString('umroh_jenis_perjalanan');
    final isFinished = prefs.getString('umroh_status');

    print(
        'Data Umroh didapatkan: jenis_perjalanan = $jenisPerjalanan, isFinished = $isFinished');

    return {
      'jenis_perjalanan': jenisPerjalanan,
      'isFinished': isFinished,
    };
  }

// Get Towaf Wada
  static Future<Map<String, String?>> getTowafwada() async {
    final prefs = await SharedPreferences.getInstance();

    final jenisPerjalanan = prefs.getString('tawafwada_jenis_perjalanan');
    final isFinished = prefs.getString('tawafwada_status');

    print(
        'Data Towaf Wada didapatkan: jenis_perjalanan = $jenisPerjalanan, isFinished = $isFinished');

    return {
      'jenis_perjalanan': jenisPerjalanan,
      'isFinished': isFinished,
    };
  }
}
