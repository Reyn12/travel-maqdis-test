import 'package:flutter/material.dart';

class WHeaderColumnTitle extends StatelessWidget {
  const WHeaderColumnTitle(
      {super.key, this.headerSubtitle, required this.headerTitle});

  final String? headerSubtitle;
  final String headerTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 80, 20, 0),
          alignment: Alignment.bottomLeft,
          child: Text(
            headerSubtitle ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Text(
            headerTitle,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              height: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
