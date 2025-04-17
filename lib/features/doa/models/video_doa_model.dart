class VideoDoaModel {
  final String videoId;
  final String judul;
  final String deskripsi;
  final String thumbnail;
  final String videoUrl;
  final String createdAt;

  VideoDoaModel({
    required this.videoId,
    required this.judul,
    required this.deskripsi,
    required this.thumbnail,
    required this.videoUrl,
    required this.createdAt,
  });

  factory VideoDoaModel.fromJson(Map<String, dynamic> json) {
    return VideoDoaModel(
      videoId: json['videoid'] ?? '',
      judul: json['judul_vid'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      videoUrl: json['link_vid'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoid': videoId,
      'judul_vid': judul,
      'deskripsi': deskripsi,
      'thumbnail': thumbnail,
      'link_vid': videoUrl,
      'created_at': createdAt,
    };
  }
}
