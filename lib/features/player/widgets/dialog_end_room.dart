import 'package:flutter/material.dart';
import 'package:maqdis_connect/core/common/widgets/w_alert_dialog.dart';
import 'package:maqdis_connect/features/player/controllers/audio_room_controller.dart';
import 'package:maqdis_connect/features/room/services/local/room_data.dart';
import 'package:lottie/lottie.dart';

class DialogEndRoom extends StatelessWidget {
  final AudioRoomController audioRoomController;

  const DialogEndRoom({
    super.key,
    required this.audioRoomController,
  });

  @override
  Widget build(BuildContext context) {
    return WAlertDialog(
      dialogTitle: 'Apakah anda yakin ingin mengakhiri perjalanan?',
      buttonTextLeft: 'Tidak',
      buttonTextRight: 'Ya',
      onPressedRight: () async {
        Navigator.pop(context);

        // Menampilkan animasi loading setelah dialog ditutup
        showDialog(
          context: context,
          barrierDismissible:
              false, // Jangan biarkan dialog ditutup sembarangan
          builder: (context) {
            return AlertDialog(
              elevation: 0,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/load.json', // Lokasi file JSON animasi loading
                    width: 100,
                    height: 100,
                  ),
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
        audioRoomController.finishProgress();
        audioRoomController.endRoom(
            lock: false,
            reason: audioRoomController.userName?.value ??
                'Unknown' 'mengakhiri room perjalanan');
        RoomDataSharedPreferenceService.clearTokenSpeaker();
        print('clear token speaker');
      },
    );
  }
}
