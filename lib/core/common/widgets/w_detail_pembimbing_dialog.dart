import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

class WDetailPembimbingDialog extends StatelessWidget {
  const WDetailPembimbingDialog({
    super.key,
    required this.dialogTitle,
    this.onPressed,
    required this.buttonText,
    this.fontColor = Colors.black,
    this.colorButton = Colors.white,
    this.verticalPadding = 12,
    this.horizontalPadding = 8,
    this.border,
    required this.colorImage,
    required this.isOnline,
    required this.profile,
    required this.imageName,
  });

  final String dialogTitle;
  final void Function()? onPressed;
  final String buttonText;
  final Color fontColor;
  final Color colorButton;
  final double verticalPadding;
  final double horizontalPadding;
  final BoxBorder? border;
  final Color colorImage;
  final bool isOnline;
  final String profile;
  final String imageName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      contentPadding:
          const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      actionsPadding:
          const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(20),
                splashColor: Colors.grey.withOpacity(0.3),
                highlightColor: Colors.grey.withOpacity(0.2),
                child: const Icon(
                  MingCuteIcons.mgc_close_fill,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isOnline ? Colors.green : const Color(0xFFD9D9D9),
                      width: 2,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorImage,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      profile,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            imageName,
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    dialogTitle,
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Divider(
              thickness: 2,
              color: Color(0xFFE9E9E9),
            ),
          ],
        ),
      ),
      actions: [
        Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: WCustomButton(
                    buttonWidth: 100,
                    fontColor: fontColor,
                    verticalPadding: verticalPadding,
                    horizontalPadding: horizontalPadding,
                    onPressed: onPressed,
                    buttonText: buttonText,
                    fontSize: 15,
                    buttonColor: colorButton,
                    radius: 8,
                    border: border,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: const Color(0xFFB1B1B1).withOpacity(0.25),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              bottom: 0,
              child: Image.asset(
                'assets/icon_whatsapp.png',
                scale: 2.5,
              ),
            )
          ],
        ),
      ],
    );
  }
}
