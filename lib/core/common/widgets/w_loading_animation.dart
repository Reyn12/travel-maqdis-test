import 'package:flutter/material.dart';

class WLoadingAnimation extends StatefulWidget {
  const WLoadingAnimation({super.key, this.color});

  final Color? color;

  @override
  WLoadingAnimationState createState() => WLoadingAnimationState();
}

class WLoadingAnimationState extends State<WLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: RotationTransition(
      turns: _controller,
      child: Image.asset(
        'assets/Spinner.png',
        color: widget.color,
        width: 35,
        height: 35,
      ),
    ));
  }
}
