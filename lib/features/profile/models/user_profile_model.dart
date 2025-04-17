class UserProfileModel {
  final String name;
  final String email;
  final String id;
  final String role;
  final String whatsapp;
  final bool statusLogin;
  final String lastLogin;
  final String photoUrl;

  UserProfileModel({
    required this.name,
    required this.email,
    required this.id,
    required this.role,
    required this.whatsapp,
    required this.statusLogin,
    required this.lastLogin,
    required this.photoUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // Use default empty string or handle null safely when parsing
    return UserProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      statusLogin: json['status_login'] ?? false,
      lastLogin: json['lastLogin'] ?? '',
      photoUrl: (json['profile'] != null) ? json['profile']['photo'] ?? '' : '',
    );
  }
}