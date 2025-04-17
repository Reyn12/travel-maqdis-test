class UsersOnRiwayatGrup {
  final String userId;
  final String name;
  final String role;

  UsersOnRiwayatGrup({
    required this.userId,
    required this.name,
    required this.role,
  });

  factory UsersOnRiwayatGrup.fromJson(Map<String, dynamic> json) {
    return UsersOnRiwayatGrup(
      userId: json['userid'],
      name: json['name'],
      role: json['role'],
    );
  }
}
