import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/features/group/controllers/group_controller.dart';
import 'package:maqdis_connect/features/group/models/generate_room_code.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareBottomSheet extends StatelessWidget {
  ShareBottomSheet({super.key});

  final GroupController _groupController = Get.find<GroupController>();

  @override
  Widget build(BuildContext context) {
    // Panggil API saat Bottom Sheet ditampilkan
    _groupController.getRoomCode();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(
              'Bagikan',
              style:
                  GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Loader saat fetch data
            Obx(() {
              if (_groupController.isLoading.value) {
                return const CircularProgressIndicator();
              }

              final roomCode = _groupController.roomCode.value;
              if (roomCode == null) {
                return const Text("Gagal memuat data.");
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: roomCode.roomCodeSpeaker != null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildListTile('Kode Room Ustadz :',
                                  roomCode.roomCodeSpeaker ?? ''),
                              const SizedBox(height: 8),
                              _buildListTile('Link Room Ustadz :',
                                  roomCode.roomSpeakerUrl ?? ''),
                              const SizedBox(height: 8),
                              const Divider(
                                thickness: 3,
                                color: Color(0xFFE9E9E9),
                              ),
                            ],
                          ),
                        ),
                        _buildListTile(
                            'Kode Room Jamaah :', roomCode.roomCodeListener),
                        const SizedBox(height: 8),
                        _buildListTile(
                            'Link Room Jamaah :', roomCode.roomListenerUrl),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildShareOptions(roomCode),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        IntrinsicWidth(
          child: Container(
            margin: const EdgeInsets.only(top: 4),
            padding:
                const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 4),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.lato(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    iconSize: 14,
                    splashRadius: 12,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: text));
                      Get.snackbar("Disalin", "Teks berhasil disalin!");
                    },
                    icon: const Icon(Icons.copy),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShareOptions(RoomCodeModel roomCode) {
    final message = """
🎤 Kode Room Ustadz :\n${roomCode.roomCodeSpeaker ?? 'N/A'}
🔗 Link Room Ustadz :\n${roomCode.roomSpeakerUrl ?? 'N/A'}
🎧 Kode Room Jamaah :\n${roomCode.roomCodeListener}
🔗 Link Room Jamaah :\n${roomCode.roomListenerUrl}

  Ayo join room ini sekarang! 🎙️🎧
  """;

    final messageJamaahOnly = """
🎧 Kode Room Jamaah :\n${roomCode.roomCodeListener}
🔗 Link Room Jamaah :\n${roomCode.roomListenerUrl}

  Ayo join room ini sekarang! 🎙️🎧
  """;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text("Bagikan ke:",
              style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 16),
              _buildShareButton(
                icon: MingCuteIcons.mgc_whatsapp_line,
                color: Colors.green,
                text: 'WhatsApp',
                onTap: () => _launchUrl(
                    'https://wa.me/?text=${Uri.encodeComponent(roomCode.roomCodeSpeaker != null ? message : messageJamaahOnly)}'),
              ),
              // const SizedBox(width: 10),
              // _buildShareButton(
              //   icon: MingCuteIcons.mgc_message_1_line,
              //   color: const Color.fromARGB(255, 75, 223, 80),
              //   text: 'Pesan',
              //   onTap: () => _launchUrl(
              //       'sms:?body=${Uri.encodeComponent(roomCode.roomCodeSpeaker != null ? message : messageJamaahOnly)}'),
              // ),
              // const SizedBox(width: 10),
              // _buildShareButton(
              //   icon: Icons.facebook,
              //   color: Colors.blue,
              //   text: 'Facebook',
              //   onTap: () => _launchUrl(
              //       'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(roomCode.roomCodeSpeaker != null ? message : messageJamaahOnly)}'),
              // ),
              const SizedBox(width: 10),
              _buildShareButton(
                icon: Icons.telegram,
                color: Colors.lightBlue,
                text: 'Telegram',
                onTap: () => _launchUrl(
                    'https://t.me/share/url?url=${Uri.encodeComponent(roomCode.roomCodeSpeaker != null ? message : messageJamaahOnly)}'),
              ),
              const SizedBox(width: 10),
              _buildShareButton(
                icon: Icons.more_horiz,
                color: Colors.grey,
                text: 'Lainnya',
                onTap: () => _shareToOthers(
                  roomCode.roomCodeSpeaker != null
                      ? message
                      : messageJamaahOnly,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Aplikasi tidak dapat dibuka");
    }
  }

  void _shareToOthers(String message) {
    Share.share(message, subject: "Join Room!");
  }

  Widget _buildShareButton({
    required IconData icon,
    required Color color,
    required String text,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 30),
          ),
        ),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
