class SharedPreferencesModel {
  SharedPreferencesModel({
    required this.iduser,
    required this.username,
    required this.email,
    required this.nowa,
    required this.photo,
    required this.createdAt,
    required this.token,
    required this.lastLogin,
    required this.role,
  });

  factory SharedPreferencesModel.fromPrefs(Map<String, String> prefs) {
    return SharedPreferencesModel(
      iduser: prefs['id'] ?? '',
      username: prefs['username'] ?? '',
      email: prefs['email'] ?? '',
      nowa: prefs['whatsapp'] ?? '',
      photo: prefs['photo'] ?? '',
      createdAt: prefs['createdAt'] ?? '',
      token: prefs['token'] ?? '',
      lastLogin: prefs['lastLogin'] ?? '',
      role: prefs['role'] ?? '',
    );
  }
  final String iduser;
  final String username;
  final String email;
  final String nowa;
  final String photo;
  final String createdAt;
  final String token;
  final String lastLogin;
  final String role;

  Map<String, String> toPrefsMap() {
    return {
      'id': iduser,
      'username': username,
      'email': email,
      'whatsapp': nowa,
      'photo': photo,
      'createdAt': createdAt,
      'role': role,
      'token': token,
      'lastLogin': lastLogin,
    };
  }
}
