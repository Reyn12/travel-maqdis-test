import 'package:flutter/material.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';

class WBerandaCard extends StatelessWidget {
  const WBerandaCard({
    super.key,
    required this.name,
    required this.assets,
    required this.assetWidth,
    this.onPressed,
  });

  final String name;
  final String assets;
  final void Function()? onPressed;
  final double assetWidth;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 3,
        child: Container(
          height: MediaQuery.of(context).size.height / 4,
          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: ElevatedButton(
              style: ButtonStyle(
                  minimumSize:
                      WidgetStateProperty.all(const Size.fromHeight(120)),
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(15)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.grey)))),
              onPressed: onPressed,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: GlobalColors.mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    assets,
                    width: assetWidth,
                  )
                ],
              )),
        ));
  }
}
