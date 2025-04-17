import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/features/group/controllers/group_controller.dart';
import 'package:maqdis_connect/features/group/controllers/perjalanan_controller.dart';
import 'package:maqdis_connect/features/group/controllers/waiting_polls_controller.dart';
import 'package:maqdis_connect/features/room/controllers/player-Controller/room_refresh_token_controller.dart';
import 'package:maqdis_connect/features/room/services/local/room_data.dart';

class BuildActionButton extends StatelessWidget {
  const BuildActionButton(
      {super.key,
      required this.statusMap,
      required this.perjalananController,
      required this.onPressedBack});

  final Map<String, bool> statusMap;
  final PerjalananController perjalananController;
  final VoidCallback onPressedBack;

  @override
  Widget build(BuildContext context) {
    final playerController = Get.find<RoomRefreshTokenController>();
    final groupController = Get.find<GroupController>();
    final waitingPollsController = Get.find<WaitingPollsController>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: statusMap['manasik'] == true &&
              statusMap['umroh'] == true &&
              statusMap['tawaf wada'] == true
          ? const SizedBox.shrink()
          : Row(
              children: [
                Expanded(
                  child: Obx(
                    () {
                      bool isPollingActive =
                          !waitingPollsController.isPollingActive.value;
                      return WCustomButton(
                        onPressed: isPollingActive ? () {} : onPressedBack,
                        buttonText: 'Kembali',
                        fontColor:
                            isPollingActive ? Colors.white : Colors.black,
                        buttonColor: isPollingActive
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.white,
                        border: Border.all(
                          color: isPollingActive
                              ? Colors.grey.withOpacity(0.3)
                              : Colors.black,
                        ),
                        fontSize: 16,
                        verticalPadding: 11,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(
                    () {
                      bool isPollingActive =
                          !waitingPollsController.isPollingActive.value;
                      return WCustomButton(
                        onPressed: isPollingActive
                            ? () {}
                            : () =>
                                mulaiRoom(playerController, groupController),
                        buttonText: 'Mulai',
                        buttonColor: isPollingActive
                            ? Colors.grey.withOpacity(0.3)
                            : const Color(0xFF25D158),
                        fontSize: 16,
                        verticalPadding: 12,
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }

  void mulaiRoom(RoomRefreshTokenController playerController,
      GroupController groupController) async {
    // Validasi apakah jenisPerjalanan telah dipilih
    if (perjalananController.selectedJenisPerjalanan.value.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Pilih jenis perjalanan terlebih dahulu!',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    try {
      // Memanggil fungsi getRoomRefreshToken dari PlayerController
      await playerController.getRoomRefreshToken();

      print(
          'ini selected ${perjalananController.selectedJenisPerjalanan.value}');

      // Memanggil fungsi postProgress
      await perjalananController.postProgress(
        perjalananController.selectedJenisPerjalanan.value,
      );

      // Tunggu hingga token_speaker tersimpan dan siap digunakan
      await _ensureTokenIsSaved();

      // Setelah token tersimpan, cek dan navigasi ke halaman berikutnya
      final token = await RoomDataSharedPreferenceService.getTokenSpeaker();
      if (token != null) {
        // Get.toNamed('/PlayerNew');
        // groupController.cekLiveData();
        // Get.off(() => const AudioRoomScreen());
        // groupController.stopCekLiveTimer();
        // Pastikan stopCekLiveTimer selesai sebelum pindah halaman

        // Pindah ke halaman audio room setelah timer benar-benar berhenti
        // Get.offAllNamed('/audioRoomScreen');
        // Get.to(() => RoomPage());
        // Get.offAll(() => const MeetingPage());
      } else {
        Fluttertoast.showToast(
          msg: 'Token tidak ditemukan. Gagal melanjutkan.',
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (e) {
      // Menampilkan pesan error jika postProgress gagal
      Fluttertoast.showToast(
        msg: 'Terjadi kesalahan: $e',
        toastLength: Toast.LENGTH_SHORT,
      );

      print('kesalahan progress: $e');
    }
  }

//   void keluarGrup(GroupController groupController) async {
//     groupController.isLoading.value = true; // Tampilkan loading jika perlu

//     // Memanggil exitGrup dari controller
//     bool success = await groupController.exitGrup();
//     if (success) {
//       Get.snackbar("Berhasil", "Anda telah keluar dari grup.");
//       // navigate ke halaman home
//       Get.offAll(() => Home());
//       if (statusMap['manasik'] == true &&
//           statusMap['umroh'] == true &&
//           statusMap['tawaf wada'] == true) {
//         Get.delete<GroupController>();
//       }
// // Delete controller
//     } else {
//       Get.snackbar("Gagal", "Gagal keluar dari grup.");
//     }
//     if (statusMap['manasik'] == true &&
//         statusMap['umroh'] == true &&
//         statusMap['tawaf wada'] == true) {
//       Get.delete<GroupController>();
//     }
//   }

  // Fungsi untuk memastikan token sudah tersimpan
  Future<void> _ensureTokenIsSaved() async {
    // Menunggu hingga token tersimpan dengan memeriksa SharedPreferences
    bool isTokenSaved = false;
    while (!isTokenSaved) {
      String? tokenSpeaker =
          await RoomDataSharedPreferenceService.getTokenSpeaker();
      if (tokenSpeaker != null) {
        isTokenSaved = true;
        print('Token Speaker berhasil disimpan: $tokenSpeaker');
      } else {
        await Future.delayed(const Duration(
            milliseconds: 3000)); // Tunggu setengah detik sebelum mencoba lagi
      }
    }
  }
}
