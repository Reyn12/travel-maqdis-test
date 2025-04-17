import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WDeleteAnimation extends StatefulWidget {
  const WDeleteAnimation({super.key, this.color});

  final Color? color;

  @override
  WDeleteAnimationState createState() => WDeleteAnimationState();
}

class WDeleteAnimationState extends State<WDeleteAnimation> {
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
        child: Center(child: Lottie.asset('assets/delete_anim.json')));
  }
}
