import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppController extends GetxController {
  void launchWhatsApp(String noWhatsApp) async {
    String phoneNumber = noWhatsApp.replaceAll(RegExp(r'[^0-9+]'), '');

    if (phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.replaceFirst('0', '+62');
    }

    final Uri waUrl = Uri.parse('https://wa.me/$phoneNumber');

    if (await canLaunchUrl(waUrl)) {
      await launchUrl(waUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Gagal membuka WhatsApp',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
