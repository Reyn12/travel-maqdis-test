class CheckUserInGroupModel {
  final String userId;
  final String name;
  final String role;
  final String email;
  final String whatsapp;
  final String photo;
  final String online;

  CheckUserInGroupModel({
    required this.userId,
    required this.name,
    required this.role,
    required this.email,
    required this.whatsapp,
    required this.photo,
    required this.online,
  });

  factory CheckUserInGroupModel.fromJson(Map<String, dynamic> json) {
    return CheckUserInGroupModel(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      photo: json['profile'] ?? '',
      online: json['online'] ?? '',
    );
  }
}

class CheckUserInGroupResponse {
  final String? roomId;
  final List<CheckUserInGroupModel> users;

  CheckUserInGroupResponse({required this.roomId, required this.users});

  factory CheckUserInGroupResponse.fromJson(Map<String, dynamic> json) {
    return CheckUserInGroupResponse(
      roomId: json['roomId'],
      users: (json['data'] as List)
          .map((data) => CheckUserInGroupModel.fromJson(data))
          .toList(),
    );
  }
}
