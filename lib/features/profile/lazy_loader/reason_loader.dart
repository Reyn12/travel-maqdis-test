import 'package:flutter/material.dart';

class ReasonLoader extends StatelessWidget {
  const ReasonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 80, bottom: 10),
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFE9E9E9),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 140, bottom: 26),
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFE9E9E9),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 9),
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFE9E9E9),
            ),
          ),
          itemCount: 6,
        ),
      ],
    );
  }
}
