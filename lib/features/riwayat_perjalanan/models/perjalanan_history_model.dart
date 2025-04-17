// import 'package:maqdis_connect/features/riwayat_perjalanan/models/doa_histroy_model.dart';

// class RiwayatPerjalanan {
//   final String riwayatPerjalananId;
//   final String namaPerjalanan;
//   final DateTime waktuMulai;
//   final DateTime waktuSelesai;
//   final String durasiProgress;
//   final List<RiwayatDoa> riwayatDoa;

//   RiwayatPerjalanan({
//     required this.riwayatPerjalananId,
//     required this.namaPerjalanan,
//     required this.waktuMulai,
//     required this.waktuSelesai,
//     required this.durasiProgress,
//     required this.riwayatDoa,
//   });

//   factory RiwayatPerjalanan.fromJson(Map<String, dynamic> json) {
//     return RiwayatPerjalanan(
//       riwayatPerjalananId: json['riwayatperjalananid'],
//       namaPerjalanan: json['nama_perjalanan'],
//       waktuMulai: DateTime.parse(json['waktu_mulai']),
//       waktuSelesai: DateTime.parse(json['time_selesai']),
//       durasiProgress: json['durasi_progress'],
//       riwayatDoa: (json['riwayatDoa'] as List)
//           .map((doa) => RiwayatDoa.fromJson(doa))
//           .toList(),
//     );
//   }
// }

import 'package:maqdis_connect/features/riwayat_perjalanan/models/doa_histroy_model.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/models/users_on_riwayat_grup_model.dart';

class RiwayatPerjalanan {
  final String riwayatPerjalananId;
  final String namaPerjalanan;
  final DateTime waktuMulai;
  final DateTime waktuSelesai;
  final String durasiProgress;
  final List<RiwayatDoa> riwayatDoa;
  final List<UsersOnRiwayatGrup> usersOnRiwayatGrup;

  RiwayatPerjalanan({
    required this.riwayatPerjalananId,
    required this.namaPerjalanan,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.durasiProgress,
    required this.riwayatDoa,
    required this.usersOnRiwayatGrup,
  });

  factory RiwayatPerjalanan.fromJson(Map<String, dynamic> json) {
    return RiwayatPerjalanan(
      riwayatPerjalananId: json['riwayatperjalananid'],
      namaPerjalanan: json['nama_perjalanan'],
      waktuMulai: DateTime.parse(json['waktu_mulai']),
      waktuSelesai: DateTime.parse(json['time_selesai']),
      durasiProgress: json['durasi_progress'],
      riwayatDoa: (json['riwayatDoa'] as List)
          .map((doa) => RiwayatDoa.fromJson(doa))
          .toList(),
      usersOnRiwayatGrup: (json['riwayatGrup']['usersOnRiwayatGrup'] as List)
          .map((user) => UsersOnRiwayatGrup.fromJson(user))
          .toList(),
    );
  }
}
