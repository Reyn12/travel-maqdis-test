import 'package:flutter/material.dart';

class ProfileBuildInfo extends StatelessWidget {
  const ProfileBuildInfo({
    super.key,
    required this.children,
    this.paddingTop = 20,
    this.paddingBottom = 20,
    this.paddingLeft = 20,
    this.paddingRight = 20,
    this.cardBackground = true,
  });

  final List<Widget> children;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final bool cardBackground;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.only(
          top: paddingTop,
          bottom: paddingBottom,
          left: paddingLeft,
          right: paddingRight,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
                color: const Color(0xFFB1B1B1).withOpacity(0.25),
              ),
            ],
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            image: cardBackground
                ? const DecorationImage(
                    image: AssetImage('assets/perjalanan_card.png'),
                    alignment: Alignment.topCenter)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}
