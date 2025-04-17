import 'package:flutter/material.dart';

class WHeaderCenterTitle extends StatelessWidget {
  const WHeaderCenterTitle({super.key, required this.headerTitle});

  final String headerTitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          headerTitle,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
