class RiwayatDoa {
  final String riwayatDoaId;
  final String judulDoa;
  final String durasiDoa;
  final bool cekDoa;

  RiwayatDoa({
    required this.riwayatDoaId,
    required this.judulDoa,
    required this.durasiDoa,
    required this.cekDoa,
  });

  factory RiwayatDoa.fromJson(Map<String, dynamic> json) {
    return RiwayatDoa(
      riwayatDoaId: json['riwayatdoaid'],
      judulDoa: json['judul_doa'],
      durasiDoa: json['durasi_doa'],
      cekDoa: json['cek_doa'],
    );
  }
}
