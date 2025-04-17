import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_detail_pembimbing_dialog.dart';
import 'package:maqdis_connect/features/group/controllers/whatsapp_controller.dart';

class DialogDetailPembimbing extends StatelessWidget {
  final String namaPembimbing;
  final String noWhatsApp;
  final Color colorImage;
  final bool isOnline;
  final String profile;
  final String imageName;
  final void Function()? onPressed;

  final WhatsAppController whatsAppController = Get.put(WhatsAppController());

  DialogDetailPembimbing({
    super.key,
    required this.namaPembimbing,
    required this.noWhatsApp,
    required this.colorImage,
    required this.isOnline,
    required this.profile,
    required this.imageName,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return WDetailPembimbingDialog(
      onPressed: () {
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 300), () {
          print('membuka whatsapp');
          whatsAppController.launchWhatsApp(noWhatsApp);
        });
      },
      dialogTitle: namaPembimbing,
      buttonText: noWhatsApp,
      colorImage: colorImage,
      isOnline: isOnline,
      profile: profile,
      imageName: imageName,
    );
  }
}
