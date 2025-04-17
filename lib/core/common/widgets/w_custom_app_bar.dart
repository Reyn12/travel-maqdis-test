// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class WCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final void Function()? onPressed;
//   final bool centerTitle;
//   final String? title;
//   final bool customAction;
//   final Widget? actionWidget;
//   final bool customBackButton;
//   final bool customLeftWidget;
//   final bool removeBackButton;
//   final Color backgroundColor;
//   final Widget? leftWidget;

//   const WCustomAppBar({
//     super.key,
//     this.onPressed,
//     this.centerTitle = false,
//     this.title,
//     this.customAction = false,
//     this.customBackButton = false,
//     this.customLeftWidget = false,
//     this.removeBackButton = false,
//     this.actionWidget,
//     this.backgroundColor = Colors.color_maqdis,
//     this.leftWidget,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         AppBar(
//           scrolledUnderElevation: 0,
//           leading: removeBackButton
//               ? const SizedBox.shrink()
//               : (!customBackButton
//                   ? BackButton(onPressed: onPressed)
//                   : customLeftWidget
//                       ? const SizedBox.shrink()
//                       : leftWidget),
//           backgroundColor: backgroundColor,
//           shadowColor: Colors.transparent,
//           iconTheme: const IconThemeData(
//             color: Colors.white,
//           ),
//           centerTitle: centerTitle,
//           title: Text(
//             title ?? '',
//             style: GoogleFonts.lato(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//             ),
//           ),
//           actions: [
//             !customAction
//                 ? Padding(
//                     padding: const EdgeInsets.only(right: 10.0),
//                     child: Image.asset(
//                       'assets/stars.png',
//                       width: 50,
//                     ),
//                   )
//                 : actionWidget ?? const SizedBox.shrink(),
//           ],
//         ),
//         if (customBackButton && !removeBackButton)
//           Positioned(
//             left: 0,
//             top: 0,
//             bottom: 0,
//             child: SafeArea(
//               child: TextButton(
//                 onPressed: onPressed,
//                 style: TextButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   shape: const RoundedRectangleBorder(),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(Icons.keyboard_arrow_left, color: Colors.black),
//                     const SizedBox(width: 2),
//                     Text(
//                       'Kembali',
//                       style: GoogleFonts.lato(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         if (customBackButton && !removeBackButton && customLeftWidget)
//           leftWidget ?? const SizedBox()
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function()? onPressed;
  final bool centerTitle;
  final String? title;
  final Widget? titleWidget;
  final bool customAction;
  final Widget? actionWidget;
  final bool customBackButton;
  final bool customLeftWidget;
  final bool removeBackButton;
  final Color backgroundColor;
  final Widget? leftWidget;
  final bool isReactive;

  const WCustomAppBar({
    super.key,
    this.onPressed,
    this.centerTitle = false,
    this.title,
    this.customAction = false,
    this.customBackButton = false,
    this.customLeftWidget = false,
    this.removeBackButton = false,
    this.actionWidget,
    this.backgroundColor = const Color(0xff1D8CC6),
    this.leftWidget,
    this.titleWidget,
    this.isReactive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: backgroundColor,
          shadowColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: centerTitle,
          title: isReactive
              ? titleWidget
              : Text(
                  title ?? '',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
          leading: removeBackButton
              ? const SizedBox.shrink()
              : (!customBackButton && !customLeftWidget
                  ? BackButton(onPressed: onPressed)
                  : null),
          actions: [
            customAction
                ? actionWidget ?? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Image.asset(
                      'assets/stars.png',
                      width: 50,
                    ),
                  ),
          ],
        ),
        if (customBackButton)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: SafeArea(
              child: TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: const RoundedRectangleBorder(),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.keyboard_arrow_left, color: Colors.black),
                    const SizedBox(width: 2),
                    Text(
                      'Kembali',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (customLeftWidget && leftWidget != null)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: SafeArea(
              child: leftWidget!,
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
