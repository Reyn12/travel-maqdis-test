import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/views/no_data_view.dart';
import 'package:maqdis_connect/core/common/widgets/w_waktu_perjalanan_card.dart';
import 'package:maqdis_connect/core/utils/date_formatter.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/core/utils/time_formatter.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/controllers/group_history_controller.dart';

class DetailPerjalananBody extends StatelessWidget {
  const DetailPerjalananBody({
    super.key,
    required this.controller,
  });

  final GroupHistoryController controller;

  @override
  Widget build(BuildContext context) {
    // menampilkan halaman no data jika detail perjalanan belum tersedia/tidak ditemukan
    return Obx(() {
      final perjalanan = controller.perjalananDetail.value;

      if (perjalanan == null) {
        debugPrint(
            "🔥 perjalananDetail masih NULL di GroupHistoryController!"); // hapus debug di production
        return const NoDataView(
          title: 'Tidak ada data',
          subtitle: 'Riwayat perjalanan tidak ditemukan.',
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Perjalanan Selesai',
              style: GoogleFonts.lato(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tanggal Perjalanan',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFB1B1B1),
                  ),
                ),
                Text(
                  formatTanggal(perjalanan.waktuMulai.toString()),
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFB1B1B1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Pembimbing',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            // pengkondisian tampilan nama pembimbing/ustadz
            if (perjalanan.usersOnRiwayatGrup.isNotEmpty)
              perjalanan.usersOnRiwayatGrup.length == 1
                  ? Text(
                      perjalanan.usersOnRiwayatGrup.first.name,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFB1B1B1),
                      ),
                    )
                  : perjalanan.usersOnRiwayatGrup.length == 2
                      ? Text(
                          '${perjalanan.usersOnRiwayatGrup[0].name} & ${perjalanan.usersOnRiwayatGrup[1].name}',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFB1B1B1),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: perjalanan.usersOnRiwayatGrup
                              .asMap()
                              .entries
                              .map((entry) => Text(
                                    '${entry.key + 1}. ${entry.value.name}',
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFFB1B1B1),
                                    ),
                                  ))
                              .toList(),
                        )
            else
              const Center(
                child: Text(
                  "Pembimbing tidak ditemukan.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              'Total Waktu Perjalanan',
              style: GoogleFonts.lato(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 18),
            WWaktuPerjalananCard(
              waktuPerjalanan: perjalanan.durasiProgress.isNotEmpty
                  ? formatDurasi(perjalanan.durasiProgress)
                  : '00:00:00',
            ),
            const SizedBox(height: 26),
            Text(
              'Detail Perjalanan',
              style: GoogleFonts.lato(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 18),

            // Timeline riwayat doa
            if (perjalanan.riwayatDoa.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: perjalanan.riwayatDoa.asMap().entries.map((entry) {
                  int index = entry.key;
                  var doa = entry.value;
                  bool isLastItem = index == perjalanan.riwayatDoa.length - 1;

                  return buildTimelineTile(
                    context,
                    doa.judulDoa,
                    doa.durasiDoa,
                    doa.cekDoa,
                    isLastItem: isLastItem,
                  );
                }).toList(),
              )
            else
              const Center(
                child: Text(
                  "Riwayat doa tidak ditemukan.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }
}

Widget buildTimelineTile(
  BuildContext context,
  String title,
  String time,
  bool isCompleted, {
  bool isCurrent = false,
  bool isLastItem = false,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(isCurrent
                    ? 'assets/icon_point.png'
                    : (isCompleted
                        ? 'assets/icon_check.png'
                        : 'assets/icon_point.png')),
                scale: 2,
              ),
              color: isCurrent
                  ? GlobalColors.mainColor
                  : (isCompleted
                      ? const Color(0xFF25D158)
                      : const Color(0xFFB1B1B1)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // Garis vertikal
          if (!isLastItem)
            Container(
              width: 4,
              height: 80,
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isCurrent
                    ? GlobalColors.mainColor
                    : (isCompleted
                        ? const Color(0xFF25D158)
                        : const Color(0xFFB1B1B1)),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
        ],
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatDurasiSimple(time),
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isCurrent
                    ? GlobalColors.mainColor
                    : (isCompleted
                        ? const Color(0xFF25D158)
                        : const Color(0xFFB1B1B1)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isCurrent
                    ? 'Sedang Berlangsung'
                    : isCompleted
                        ? 'Selesai'
                        : 'Belum Dilaksanakan',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ],
  );
}
