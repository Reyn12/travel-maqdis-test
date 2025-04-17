// class LiveProgressModel {
//   final String progressId;
//   final String grupId;
//   final String jenisPerjalanan;
//   final int live;
//   final bool status;
//   final bool isFinished;

//   LiveProgressModel({
//     required this.progressId,
//     required this.grupId,
//     required this.jenisPerjalanan,
//     required this.live,
//     required this.status,
//     required this.isFinished,
//   });

//   factory LiveProgressModel.fromJson(Map<String, dynamic> json) {
//     return LiveProgressModel(
//       progressId: json['id_progress'] as String,
//       grupId: json['id_grup'] as String,
//       jenisPerjalanan: json['jenis_perjalanan'] as String,
//       live: json['live'] as int,
//       status: json['status'] as bool,
//       isFinished: json['is_finished'] as bool,
//     );
//   }
// }

// class LiveProgressModelResponse {
//   final bool status;
//   final String message;
//   final List<LiveProgressModel> data;

//   LiveProgressModelResponse({
//     required this.status,
//     required this.message,
//     required this.data,
//   });

//   factory LiveProgressModelResponse.fromJson(Map<String, dynamic> json) {
//     return LiveProgressModelResponse(
//       status: json['status'] as bool, // Perbaikan parsing status
//       message: json['message'] as String,
//       data: (json['data'] as List)
//           .map((item) =>
//               LiveProgressModel.fromJson(item as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }

class LiveProgressModel {
  final String progressId;
  final String grupId;
  final String jenisPerjalanan;
  final String perjalananId;
  final int live;
  final bool status;
  final bool isFinished;

  LiveProgressModel({
    required this.progressId,
    required this.grupId,
    required this.jenisPerjalanan,
    required this.perjalananId,
    required this.live,
    required this.status,
    required this.isFinished,
  });

  factory LiveProgressModel.fromJson(Map<String, dynamic> json) {
    return LiveProgressModel(
      progressId: json['id_progress'] as String,
      grupId: json['id_grup'] as String,
      jenisPerjalanan: json['jenis_perjalanan'] as String,
      perjalananId: json['perjalananid'] as String,
      live: json['live'] as int,
      status: json['status'] as bool,
      isFinished: json['is_finished'] ?? false,
    );
  }
}

class LiveProgressModelResponse {
  final bool status;
  final String message;
  final List<LiveProgressModel> data;

  LiveProgressModelResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LiveProgressModelResponse.fromJson(Map<String, dynamic> json) {
    return LiveProgressModelResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) =>
              LiveProgressModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
