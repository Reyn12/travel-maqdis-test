import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/player/controllers/audio_room_controller.dart';
import 'package:maqdis_connect/features/player/widgets/dialog_end_room.dart';
import 'package:lottie/lottie.dart';

class DoaFinishedWidget extends StatelessWidget {
  const DoaFinishedWidget({super.key, required this.audioRoomController});
  final AudioRoomController audioRoomController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Lottie.asset(
              'assets/umroh_anim.json',
              width: 200,
            ),
            Positioned(
              bottom: -8,
              right: 60,
              left: 60,
              child: Lottie.asset(
                'assets/success_anim.json',
                width: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Rangkaian Doa Sudah Selesai',
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<String?>(
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
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: WCustomButton(
                      verticalPadding: 10,
                      buttonText: 'Akhiri Perjalanan',
                      buttonColor: const Color(0xFFD30509),
                      onPressed: () => Get.dialog(
                        DialogEndRoom(audioRoomController: audioRoomController),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }
}
