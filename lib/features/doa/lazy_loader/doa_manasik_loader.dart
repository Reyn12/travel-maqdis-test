import 'package:flutter/material.dart';

class DoaManasikLoader extends StatelessWidget {
  const DoaManasikLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 15, 80, 10),
            height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFE9E9E9),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 140, 24),
            height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFE9E9E9),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color(0xFFE9E9E9),
                ),
              ),
              itemCount: 6,
            ),
          ),
        ],
      ),
    );
  }
}
