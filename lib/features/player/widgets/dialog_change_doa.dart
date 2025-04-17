import 'package:flutter/material.dart';
import 'package:maqdis_connect/core/common/widgets/w_alert_dialog.dart';

class DialogChangeDoa extends StatelessWidget {
  final String title;
  final String buttonTextRight;
  final void Function()? onPressedRight;
  final void Function()? onPressedLeft;

  const DialogChangeDoa({
    super.key,
    this.onPressedRight,
    this.onPressedLeft,
    required this.title,
    required this.buttonTextRight,
  });

  @override
  Widget build(BuildContext context) {
    return WAlertDialog(
      dialogTitle: 'Kamu akan pindah ke audio $title',
      buttonTextLeft: 'Batal',
      buttonTextRight: buttonTextRight,
      onPressedLeft: onPressedLeft,
      onPressedRight: onPressedRight,
    );
  }
}
