class GroupListModel {
  final String grupId;
  final String namaGrup;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? finishAt;
  final int openUser;
  final String status;
  final String userId;
  final String? roomId;

  GroupListModel({
    required this.grupId,
    required this.namaGrup,
    required this.createdBy,
    required this.createdAt,
    this.finishAt,
    required this.openUser,
    required this.status,
    required this.userId,
    this.roomId,
  });

  // Factory method for JSON serialization
  factory GroupListModel.fromJson(Map<String, dynamic> json) {
    return GroupListModel(
      grupId: json['grupid'],
      namaGrup: json['nama_grup'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      finishAt:
          json['finish_at'] != null ? DateTime.parse(json['finish_at']) : null,
      openUser:
          int.tryParse(json['open_user'].toString()) ?? 0, // Convert to int
      status: json['status'],
      userId: json['userId'],
      roomId: json['roomid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grupid': grupId,
      'nama_grup': namaGrup,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'finish_at': finishAt?.toIso8601String(),
      'open_user': openUser,
      'status': status,
      'userId': userId,
      'roomid': roomId,
    };
  }
}
