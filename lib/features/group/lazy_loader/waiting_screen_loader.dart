import 'package:flutter/material.dart';

class WaitingScreenLoader extends StatelessWidget {
  const WaitingScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xFFE9E9E9),
        ),
      ),
      itemCount: 6,
    );
  }
}
