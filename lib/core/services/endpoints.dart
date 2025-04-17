class Endpoints {
  // String baseUrl = 'apitravel.maqdisacademy.com';
  static const String baseUrl2 =
      'https://apitravel.nikahinaja.com/'; // server kang rian
  // static const String baseUrl2 = 'https://hnd1sw9p-5000.asse.devtunnels.ms/'; // local
  // static const String baseUrl2 =
  //     'https://dwltv637-5000.asse.devtunnels.ms/'; // Back-End Arkan
  static const String registerUrl = 'api/auth/register';
  static const String loginUrl = 'api/auth/login';
  static const String loginGoogle = 'api/auth/google';
  static const String logoutUrl = 'api/auth/logout';
  static const String getProfileUrl = 'api/profile/me';
  static const String updateProfileUrl = 'api/profile';
  static const String cekUserGrup = 'api/Group/CekUserGrup';
  static const String getGrup = 'api/Group';
  static const String liveProgress = 'api/Group/getCekLive';
  static const String checkToken = 'api/protected';
  static const String getListGrup = 'api/Group';
  static const String urlRoomRefresh = 'api/Audio/refreshToken';
  static const String getPesertaGroup = 'api/Group/peserta';
}
