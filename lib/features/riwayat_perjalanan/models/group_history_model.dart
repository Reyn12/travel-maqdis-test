// class GroupHistory {
//   final String namaGrup;
//   final String grupId;

//   GroupHistory({
//     required this.namaGrup,
//     required this.grupId,
//   });

//   factory GroupHistory.fromJson(Map<String, dynamic> json) {
//     return GroupHistory(
//       namaGrup: json['nama_grup'],
//       grupId: json['grupid'],
//     );
//   }
// }

// class GroupHistoryResponse {
//   final String msg;
//   final List<GroupHistory> data;

//   GroupHistoryResponse({
//     required this.msg,
//     required this.data,
//   });

//   factory GroupHistoryResponse.fromJson(Map<String, dynamic> json) {
//     var list = json['data'] as List;
//     List<GroupHistory> grupList =
//         list.map((e) => GroupHistory.fromJson(e)).toList();

//     return GroupHistoryResponse(
//       msg: json['msg'],
//       data: grupList,
//     );
//   }
// }

class RiwayatGrup {
  final String riwayatGrupId;
  final String namaGrup;

  RiwayatGrup({
    required this.riwayatGrupId,
    required this.namaGrup,
  });

  factory RiwayatGrup.fromJson(Map<String, dynamic> json) {
    return RiwayatGrup(
      riwayatGrupId: json['riwayatgrupid'],
      namaGrup: json['nama_grup'],
    );
  }
}
