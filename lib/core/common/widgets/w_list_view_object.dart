import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';

class WListViewObject extends StatelessWidget {
  final void Function() onPressed;
  final double paddingTop;
  final bool isExpandedBtn;
  final bool trailingBtn;
  final bool imageBackground;
  final String number;
  final String title;
  final int maxLines;
  final String buttonText;
  final bool divider;
  final Widget? customWidget;
  final MainAxisAlignment mainAxisAlignment;
  final Color buttonColor;
  final bool spacer;

  const WListViewObject({
    Key? key,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.paddingTop = 0,
    this.isExpandedBtn = true,
    this.trailingBtn = true,
    this.imageBackground = false,
    required this.onPressed,
    required this.number,
    required this.title,
    this.buttonText = 'Masuk',
    this.divider = true,
    this.customWidget,
    this.buttonColor = const Color(0xff1D8CC6),
    this.maxLines = 1,
    this.spacer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB1B1B1).withOpacity(0.25),
            offset: const Offset(0, 0),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
        image: imageBackground
            ? const DecorationImage(
                image: AssetImage('assets/perjalanan_card.png'),
                alignment: Alignment.topCenter,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: mainAxisAlignment,
            children: [
              Container(
                height: 37,
                width: 37,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: GlobalColors.mainColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: GlobalColors.mainColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF292D32),
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Visibility(visible: spacer, child: const Spacer()),
          Visibility(
            visible: divider,
            child: Divider(
              color: const Color(0xFFECECEC).withOpacity(0.6),
              thickness: 1.5,
              height: 30,
            ),
          ),
          Visibility(
            visible: !divider,
            child: const SizedBox(height: 10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customWidget ?? const SizedBox.shrink(),
              isExpandedBtn
                  ? Expanded(
                      child: WCustomButton(
                        trailing: trailingBtn,
                        onPressed: onPressed,
                        buttonText: buttonText,
                        buttonColor: buttonColor,
                      ),
                    )
                  : WCustomButton(
                      trailing: trailingBtn,
                      onPressed: onPressed,
                      buttonText: buttonText,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
