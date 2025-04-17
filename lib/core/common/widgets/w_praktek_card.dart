// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class WPraktekCard extends StatelessWidget {
//   const WPraktekCard({
//     super.key,
//     required this.cardImage,
//     required this.leadingImage,
//     required this.title,
//     required this.subtitle,
//     this.onTap,
//     this.isDisabled = false,
//   });

//   final VoidCallback? onTap;
//   final String cardImage;
//   final String leadingImage;
//   final String title;
//   final String subtitle;
//   final bool isDisabled;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: isDisabled ? null : onTap,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           image: DecorationImage(
//             image: AssetImage('assets/cards/$cardImage'),
//             fit: BoxFit.cover,
//             colorFilter: isDisabled
//                 ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
//                 : null,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Image.asset(
//                   leadingImage,
//                   height: 70,
//                 ),
//               ),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: GoogleFonts.lato(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       subtitle,
//                       style: GoogleFonts.lato(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Text(
//                           isDisabled ? 'SEGERA HADIR!' : 'Mulai Disini',
//                           style: GoogleFonts.lato(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Visibility(
//                           visible: !isDisabled,
//                           child: const Icon(
//                             Icons.keyboard_arrow_right,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WPraktekCard extends StatefulWidget {
  const WPraktekCard({
    super.key,
    required this.cardImage,
    required this.leadingImage,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.isDisabled = false,
  });

  final VoidCallback? onTap;
  final String cardImage;
  final String leadingImage;
  final String title;
  final String subtitle;
  final bool isDisabled;

  @override
  _WPraktekCardState createState() => _WPraktekCardState();
}

class _WPraktekCardState extends State<WPraktekCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward(); // Start animation immediately

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // start position from bottom
      end: Offset.zero, // end position (original)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // Smooth curve for the animation
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: GestureDetector(
        onTap: widget.isDisabled ? null : widget.onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage('assets/cards/${widget.cardImage}'),
              fit: BoxFit.cover,
              colorFilter: widget.isDisabled
                  ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                  : null,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    widget.leadingImage,
                    height: 70,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.subtitle,
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            widget.isDisabled
                                ? 'SEGERA HADIR!'
                                : 'Mulai Disini',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Visibility(
                            visible: !widget.isDisabled,
                            child: const Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
