import 'package:flutter/material.dart';

class WAnimatedFade extends StatefulWidget {
  final Widget? child;
  const WAnimatedFade({super.key, this.child});

  @override
  WAnimatedFadeState createState() => WAnimatedFadeState();
}

class WAnimatedFadeState extends State<WAnimatedFade> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _opacity = 1.0; // Mulai animasi fade-in
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 1000), // Durasi fade-in
      curve: Curves.easeInOut, // Efek transisi halus
      child: widget.child,
    );
  }
}
