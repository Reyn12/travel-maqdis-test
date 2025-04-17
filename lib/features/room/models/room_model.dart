class RoomModelResponse {
  RoomModelResponse({
    required this.status,
    required this.message,
    required this.room,
  });

  factory RoomModelResponse.fromJson(Map<String, dynamic> json) {
    return RoomModelResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      room: RoomDataModel.fromJson(json['room'] as Map<String, dynamic>),
    );
  }
  final String status;
  final String message;
  final RoomDataModel room;
}

class RoomDataModel {
  RoomDataModel({
    required this.id,
    required this.namaRoom,
    required this.tokenSpeaker,
    required this.tokenListener,
  });

  factory RoomDataModel.fromJson(Map<String, dynamic> json) {
    return RoomDataModel(
      id: json['id'] as String,
      namaRoom: json['nama_room'] as String,
      tokenSpeaker: json['token_speaker'] as String,
      tokenListener: json['token_listener'] as String,
    );
  }
  final String id;
  final String namaRoom;
  final String tokenSpeaker;
  final String tokenListener;
}
