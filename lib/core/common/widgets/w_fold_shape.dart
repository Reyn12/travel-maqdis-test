import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoldShape extends StatelessWidget {
  const FoldShape({super.key, required this.index});

  final String index;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 27,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.zero,
                topRight: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Center(
                child: Text(
              index,
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            )),
          ),
          Positioned(
            bottom: -5,
            left: 0,
            child: Container(
              width: 4,
              height: 5,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 204, 204, 204),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
