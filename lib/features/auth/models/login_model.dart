class LoginModel {
  final String status;
  final String username;
  final String email;
  final String token;
  final String id;
  final String role;
  final String? roomId;
  final String? groupId; // Untuk menyimpan grupid pertama (jika ada)
  final String photo;

  LoginModel({
    required this.status,
    required this.username,
    required this.email,
    required this.token,
    required this.id,
    this.roomId,
    required this.role,
    this.groupId,
    required this.photo,
  });

  // Metode factory untuk membuat objek UserLogin dari data JSON
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    String? groupId;
    if (json['groups'] != null && (json['groups'] as List).isNotEmpty) {
      groupId = json['groups'][0]['grupid'] as String?;
    }

    return LoginModel(
      status: json['status'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      roomId: json['room'] ?? '',
      groupId: groupId,
      photo: json['photo'] ?? '',
    );
  }
}

class LogoutModel {
  final bool status;
  final String message;
  final String datas;

  LogoutModel(
      {required this.status, required this.message, required this.datas});

  factory LogoutModel.createPostResult(
      Map<String, dynamic> object, int statusCode) {
    return LogoutModel(
        status: object['status'],
        message: object['message'],
        datas: object['data']);
  }
}
