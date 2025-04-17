import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PeerTrackNode {
  PeerTrackNode({
    required this.uid,
    required this.peer,
    this.audioTrack,
    this.isRaiseHand = false,
  });
  String uid;
  HMSPeer peer;
  bool isRaiseHand;
  HMSTrack? audioTrack;

  @override
  String toString() {
    return 'PeerTrackNode{uid: $uid, peerId: ${peer.peerId},track: $audioTrack}';
  }
}

// class GroupModel {
//   final String grupid;
//   final String namaGrup;
//   final String createdBy;
//   final DateTime createdAt;
//   final int openUser;
//   final String status;
//   final String userId;
//   final String? roomId;
//   final dynamic room;

//   GroupModel({
//     required this.grupid,
//     required this.namaGrup,
//     required this.createdBy,
//     required this.createdAt,
//     required this.openUser,
//     required this.status,
//     required this.userId,
//     this.roomId,
//     this.room,
//   });
// }
