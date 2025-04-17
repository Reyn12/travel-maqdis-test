import 'package:flutter/material.dart';

class DoaManasikDetailLoader extends StatelessWidget {
  const DoaManasikDetailLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFE9E9E9),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 15, 80, 14),
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFFE9E9E9),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFFE9E9E9),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFFE9E9E9),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFFE9E9E9),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 140, 24),
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFFE9E9E9),
            ),
          ),
        ],
      ),
    );
  }
}
