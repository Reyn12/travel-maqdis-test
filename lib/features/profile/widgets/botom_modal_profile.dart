import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maqdis_connect/features/profile/controllers/profile_controller.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

class BottomModalProfile extends StatelessWidget {
  const BottomModalProfile({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pilih Foto Profil',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    controller.pickPhoto(ImageSource.camera);
                  },
                  icon: const Icon(
                    MingCuteIcons.mgc_camera_2_fill,
                    size: 24,
                    color: Color.fromARGB(255, 29, 29, 29),
                  ),
                  label: Text(
                    'Camera',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton.icon(
                  onPressed: () {
                    controller.pickPhoto(ImageSource.gallery);
                  },
                  icon: const Icon(
                    MingCuteIcons.mgc_pic_fill,
                    size: 24,
                    color: Color.fromARGB(255, 29, 29, 29),
                  ),
                  label: Text(
                    'Gallery',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
