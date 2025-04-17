import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WBlueButton extends StatelessWidget {
  const WBlueButton({
    super.key,
    required this.isLoading,
    required this.text,
    required this.onPressed,
  });

  final RxBool isLoading; // Ubah menjadi reaktif
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => ElevatedButton(
          onPressed: isLoading.value ? null : onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            padding: MaterialStateProperty.all(const EdgeInsets.all(25)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: isLoading.value
              ? LoadingAnimationWidget.stretchedDots(
                  color: Colors.white,
                  size: 20,
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
        ),
      ),
    );
  }
}
