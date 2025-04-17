import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/player/controllers/audio_room_controller.dart';
import 'package:maqdis_connect/features/room/services/local/room_data.dart';
import 'package:lottie/lottie.dart';

class BottomSheetPerjalanan extends StatefulWidget {
  const BottomSheetPerjalanan({super.key, required this.audioRoomController});

  final AudioRoomController audioRoomController;

  @override
  State<BottomSheetPerjalanan> createState() => _BottomSheetPerjalananState();
}

class _BottomSheetPerjalananState extends State<BottomSheetPerjalanan> {
  // final PlayerController playerController =
  //     Get.put<PlayerController>(PlayerController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Menutup bottom sheet
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: GlobalColors.mainColor, width: 1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: GlobalColors.mainColor,
              size: 24,
            ),
            const Text(
              'Progres Perjalananmu',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Divider(height: 30, color: Colors.grey),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tampilkan timeline dengan status 'Sedang berlangsung' untuk halaman yang aktif
                      Obx(() {
                        return buildTimelineTile(
                          context,
                          "Doa untuk Orang yang ditinggalkan",
                          "",
                          widget.audioRoomController.playerController
                                  .currentIndex.value >=
                              0,
                          isCurrent: widget.audioRoomController.playerController
                                  .currentIndex.value ==
                              0,
                        );
                      }),
                      Obx(() {
                        return buildTimelineTile(
                          context,
                          "Doa untuk Orang yang meninggalkan",
                          "",
                          widget.audioRoomController.playerController
                                  .currentIndex.value >=
                              1,
                          isCurrent: widget.audioRoomController.playerController
                                  .currentIndex.value ==
                              1,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder<String?>(
                  // Memeriksa role
                  future: SharedPreferencesService.getRole(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }

                    if (snapshot.hasError) {
                      return const SizedBox.shrink();
                    }

                    final role = snapshot.data;

                    if (role == "ustadz") {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          // Tampilkan dialog konfirmasi
                          _showConfirmationDialog(
                              context, widget.audioRoomController);
                        },
                        child: const Text(
                          "Akhiri Perjalanan",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTimelineTile(
  BuildContext context,
  String title,
  String time,
  bool isCompleted, {
  bool isCurrent = false, // Indikator apakah halaman ini yang sedang diputar
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: [
          // Indikator lingkaran
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isCurrent
                  ? Colors
                      .yellowAccent[700] // Jika sedang diputar, warna kuning
                  : (isCompleted
                      ? Colors.green // Hijau jika selesai
                      : Colors.grey), // Abu-abu jika belum
              shape: BoxShape.circle,
            ),
          ),
          // Garis vertikal
          Container(
            width: 2,
            height: 40,
            color: isCurrent
                ? Colors.yellowAccent[700] // Garis kuning jika sedang diputar
                : (isCompleted
                    ? Colors.green // Garis hijau jika selesai
                    : Colors.grey), // Garis abu-abu jika belum
          ),
        ],
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Tampilkan teks berdasarkan kondisi prioritas
            Text(
              isCurrent
                  ? 'Sedang berlangsung' // Jika sedang diputar
                  : isCompleted
                      ? 'Selesai' // Jika sudah selesai dan tidak sedang diputar
                      : 'Belum berlangsung', // Jika belum diputar
              style: TextStyle(
                fontSize: 14,
                color: isCurrent
                    ? Colors
                        .yellowAccent[700] // Teks kuning jika sedang diputar
                    : isCompleted
                        ? Colors.green // Teks hijau jika selesai
                        : Colors.grey, // Teks abu-abu jika belum
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ],
  );
}

void _showConfirmationDialog(
    BuildContext context, AudioRoomController audioRoomController) {
  // Menampilkan dialog konfirmasi
  showDialog(
    context: context,
    barrierDismissible: false, // Jangan biarkan dialog ditutup sembarangan
    builder: (context) {
      return AlertDialog(
        title: const Text("Konfirmasi"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Apakah Anda yakin ingin mengakhiri perjalanan?"),
            const SizedBox(height: 20),
            Lottie.asset(
              'assets/logo.json', // Lokasi file JSON animasi loading
              width: 100,
              height: 100,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Jika "Tidak" dipilih, tutup dialog
              Navigator.of(context).pop();
            },
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () async {
              // Tutup dialog terlebih dahulu
              Navigator.of(context).pop();

              // Menampilkan animasi loading setelah dialog ditutup
              showDialog(
                context: context,
                barrierDismissible:
                    false, // Jangan biarkan dialog ditutup sembarangan
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          'assets/load.json', // Lokasi file JSON animasi loading
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 20),
                        const Text("Proses sedang berlangsung..."),
                      ],
                    ),
                  );
                },
              );

              // Simulasikan proses (misalnya 2 detik)
              await Future.delayed(const Duration(seconds: 2));

              // await Future.delayed(Duration.zero, () async {
              //   audioRoomController.stopCekLiveTimer();
              // });

              audioRoomController.endRoom(
                  lock: false,
                  reason: audioRoomController.userName?.value ??
                      'Unknown' 'mengakhiri room perjalanan');
              audioRoomController.finishProgress();
              RoomDataSharedPreferenceService.clearTokenSpeaker();
              print('clear token speaker');
              // Tutup dialog loading setelah proses selesai
              // Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text("Ya"),
          ),
        ],
      );
    },
  );
}
