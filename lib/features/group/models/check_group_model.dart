class GroupModel {
  final String grupid;
  final String namaGrup;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? finishAt;
  final int openUser;
  final String status;
  final String userId;
  final String? roomId;
  final Room? room; // Mengubah room menjadi objek Room

  GroupModel({
    required this.grupid,
    required this.namaGrup,
    required this.createdBy,
    required this.createdAt,
    this.finishAt,
    required this.openUser,
    required this.status,
    required this.userId,
    this.roomId,
    this.room,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      grupid: json['grupid'],
      namaGrup: json['nama_grup'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      finishAt:
          json['finish_at'] != null ? DateTime.parse(json['finish_at']) : null,
      openUser: json['open_user'],
      status: json['status'],
      userId: json['userId'],
      roomId: json['roomid'],
      room: json['room'] != null
          ? Room.fromJson(json['room'])
          : null, // Parsing objek room jika ada
    );
  }
}

class Room {
  final String id;
  final String namaRoom;
  final String tokenSpeaker;
  final String tokenListener;

  Room({
    required this.id,
    required this.namaRoom,
    required this.tokenSpeaker,
    required this.tokenListener,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      namaRoom: json['nama_room'],
      tokenSpeaker: json['token_speaker'],
      tokenListener: json['token_listener'],
    );
  }
}
