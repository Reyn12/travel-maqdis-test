class User {
  final String name;
  final String role;
  final bool statusLogin;

  User({
    required this.name,
    required this.role,
    required this.statusLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      role: json['role'],
      statusLogin: json['status_login'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'status_login': statusLogin,
    };
  }
}

class UserInGroup {
  final String pesertaGrupId;
  final String grupId;
  final String userId;
  final String? roomId;
  final DateTime joinedAt;
  final String online;
  final String? usersGoogleId;
  final User? user;
  final dynamic room;

  UserInGroup({
    required this.pesertaGrupId,
    required this.grupId,
    required this.userId,
    this.roomId,
    required this.joinedAt,
    required this.online,
    this.usersGoogleId,
    this.user,
    this.room,
  });

  factory UserInGroup.fromJson(Map<String, dynamic> json) {
    return UserInGroup(
      pesertaGrupId: json['peserta_grupid'],
      grupId: json['grupid'],
      userId: json['userId'],
      roomId: json['roomid'],
      joinedAt: DateTime.parse(json['joinedAt']),
      online: json['online'],
      usersGoogleId: json['usersGoogleId'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      room: json['room'], // Tetap dynamic jika tidak ada detail lebih lanjut
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'peserta_grupid': pesertaGrupId,
      'grupid': grupId,
      'userId': userId,
      'roomid': roomId,
      'joinedAt': joinedAt.toIso8601String(),
      'online': online,
      'usersGoogleId': usersGoogleId,
      'user': user?.toJson(),
      'room': room,
    };
  }
}

class CheckUserGroupModel {
  final String message;
  final UserInGroup userInGroup;

  CheckUserGroupModel({
    required this.message,
    required this.userInGroup,
  });

  factory CheckUserGroupModel.fromJson(Map<String, dynamic> json) {
    return CheckUserGroupModel(
      message: json['msg'],
      userInGroup: UserInGroup.fromJson(json['userInGroup']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': message,
      'userInGroup': userInGroup.toJson(),
    };
  }
}
