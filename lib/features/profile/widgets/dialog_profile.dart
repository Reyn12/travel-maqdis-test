import 'package:flutter/material.dart';
import 'package:maqdis_connect/core/common/widgets/w_alert_dialog.dart';

class DialogProfile extends StatelessWidget {
  const DialogProfile(
      {super.key,
      this.onPressedLeft,
      required this.dialogTitle,
      required this.buttonTextRight,
      this.onPressedRight});

  final String dialogTitle;
  final String buttonTextRight;
  final void Function()? onPressedLeft;
  final void Function()? onPressedRight;

  @override
  Widget build(BuildContext context) {
    return WAlertDialog(
      dialogTitle: dialogTitle,
      buttonTextLeft: 'Tidak',
      buttonTextRight: buttonTextRight,
      fontColorL: Colors.black,
      colorLeftButton: Colors.white,
      colorRightButton: const Color(0xFFD30509),
      verticalPaddingL: 11,
      borderL: Border.all(),
      onPressedLeft: onPressedLeft,
      onPressedRight: onPressedRight,
    );
  }
}
