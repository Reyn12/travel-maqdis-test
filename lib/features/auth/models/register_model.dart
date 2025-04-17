class RegisterModel {
  RegisterModel({
    required this.name,
    required this.email,
    required this.whatsapp,
    required this.role,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      name: json['name'] as String,
      email: json['email'] as String,
      whatsapp: json['whatsapp'] as String,
      role: json['role'] as String,
    );
  }
  final String name;
  final String email;
  final String whatsapp;
  final String role;
}
