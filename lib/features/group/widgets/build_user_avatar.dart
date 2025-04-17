import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/features/group/models/check_user_in_group.dart';
import 'package:maqdis_connect/features/group/widgets/dialog_detail_pembimbing.dart';

class BuildUserAvatar extends StatelessWidget {
  const BuildUserAvatar({
    super.key,
    required this.userData,
    required this.index,
    required this.myIdUser,
    this.fontSize = 14,
  });

  final CheckUserInGroupModel userData;
  final int index;
  final String myIdUser;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final isOnline = userData.online == '1';
    final isCurrentUser = userData.userId == myIdUser;
    bool isPressed = false;

    return InkWell(
      onTap: () {
        if (userData.role == 'ustadz' && !isCurrentUser) {
          print("User dengan role ustadz diklik!");
          Get.dialog(
            DialogDetailPembimbing(
              namaPembimbing: userData.name,
              noWhatsApp: userData.whatsapp,
              colorImage: getBackgroundColor(index),
              isOnline: isOnline,
              profile: userData.photo,
              imageName: getAvatarTitle(userData.name),
            ),
          );
        }
      },
      splashColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(isPressed ? 0.9 : 1.0),
        child: Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFFE9E9E9),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isOnline ? Colors.green : const Color(0xFFD9D9D9),
                      width: 2,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getBackgroundColor(index),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      userData.photo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            double size = constraints.maxWidth * 0.2;
                            return Center(
                              child: Text(
                                getAvatarTitle(userData.name),
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: size,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                (isCurrentUser ? "(Saya) " : "") + userData.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: isCurrentUser ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getAvatarTitle(String name) {
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  Color getBackgroundColor(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.teal
    ];
    return colors[index % colors.length];
  }
}
