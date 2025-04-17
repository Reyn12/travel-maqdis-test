class RoomCodeModel {
  final String? roomCodeSpeaker;
  final String? roomSpeakerUrl;
  final String roomCodeListener;
  final String roomListenerUrl;

  RoomCodeModel({
    this.roomCodeSpeaker,
    this.roomSpeakerUrl,
    required this.roomCodeListener,
    required this.roomListenerUrl,
  });

  factory RoomCodeModel.fromJson(Map<String, dynamic> json) {
    return RoomCodeModel(
      roomCodeSpeaker: json['roomCodeSpeaker'],
      roomSpeakerUrl: json['roomSpeakerUrl'],
      roomCodeListener: json['roomCodeListener'],
      roomListenerUrl: json['roomListenerUrl'],
    );
  }
}
