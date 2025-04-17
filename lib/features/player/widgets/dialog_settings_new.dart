import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/player/controllers/player_controller.dart';
import 'package:maqdis_connect/features/player/widgets/custom_track.dart';

class DialogSettingNew extends StatefulWidget {
  final PlayerControllerTesting playerController;
  const DialogSettingNew({super.key, required this.playerController});

  @override
  State<DialogSettingNew> createState() => _DialogSettingNewState();
}

class _DialogSettingNewState extends State<DialogSettingNew> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      backgroundColor: Colors.white,
      contentPadding:
          const EdgeInsets.only(top: 16, left: 32, right: 32, bottom: 8),
      actionsPadding:
          const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ukuran Font Arab',
                  style: GoogleFonts.lato(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    trackShape: CustomTrack(),
                    trackHeight: 3,
                  ),
                  // ),
                  child: Obx(() => Slider(
                        thumbColor: GlobalColors.mainColor,
                        activeColor: GlobalColors.mainColor,
                        inactiveColor: Colors.grey,
                        value: widget.playerController.arabicFontSize.value,
                        min: 18,
                        max: 30,
                        onChanged: (value) {
                          widget.playerController.arabicFontSize.value = value;
                        },
                      )),
                ),
                Text(
                  'Ukuran Font Terjemahan',
                  style: GoogleFonts.lato(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    trackShape: CustomTrack(),
                    trackHeight: 3,
                  ),
                  child: Obx(() => Slider(
                        value:
                            widget.playerController.translationFontSize.value,
                        thumbColor: GlobalColors.mainColor,
                        activeColor: GlobalColors.mainColor,
                        inactiveColor: Colors.grey,
                        min: 16,
                        max: 24,
                        onChanged: (value) {
                          widget.playerController.translationFontSize.value =
                              value;
                        },
                      )),
                ),
              ],
            ),
            Text(
              'Pengaturan',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
