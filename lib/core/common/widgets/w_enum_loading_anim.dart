import 'package:flutter/material.dart';
import 'package:maqdis_connect/core/enums/loading_animation.dart';

class WEnumLoadingAnim extends StatefulWidget {
  const WEnumLoadingAnim(
      {super.key,
      this.color,
      this.animation = LoadingAnimation.plane,
      this.size});

  final LoadingAnimation animation;
  final Color? color;
  final double? size;

  @override
  WEnumLoadingAnimState createState() => WEnumLoadingAnimState();
}

class WEnumLoadingAnimState extends State<WEnumLoadingAnim> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(2),
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.width / 4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: widget.animation.getWidget()));
  }
}
