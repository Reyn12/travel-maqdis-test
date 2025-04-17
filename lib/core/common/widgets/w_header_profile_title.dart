import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';

class WHeaderProfileTitle extends StatelessWidget {
  const WHeaderProfileTitle(
      {super.key,
      required this.headerTitle,
      this.onTapImg,
      this.onPressed,
      this.backgroundImage});

  // RxString untuk headerTitle
  final RxString headerTitle;
  final void Function()? onTapImg;
  final void Function()? onPressed;
  final ImageProvider<Object>? backgroundImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onTapImg,
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Hero(
                    tag: 'profileImage',
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: backgroundImage,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Obx(() {
                return Expanded(
                  child: Text(
                    headerTitle.value,
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }),
            ],
          ),
          const Spacer(),
          WCustomButton(
            buttonColor: Colors.white,
            verticalPadding: 10,
            buttonText: 'Edit Profil',
            fontColor: Colors.black,
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
