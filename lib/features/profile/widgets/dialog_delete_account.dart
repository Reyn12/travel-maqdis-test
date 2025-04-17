import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/navbar/home.dart';
import 'package:maqdis_connect/core/common/widgets/w_alert_dialog.dart';

class DialogLogoutAccount extends StatelessWidget {
  const DialogLogoutAccount({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return WAlertDialog(
      dialogTitle: 'Apakah anda yakin ingin menghapus akun secara permanen?',
      buttonTextLeft: 'Tidak',
      buttonTextRight: 'Keluar',
      fontColorL: Colors.black,
      colorLeftButton: Colors.white,
      colorRightButton: const Color(0xFFD30509),
      verticalPaddingL: 11,
      borderL: Border.all(),
      onPressedLeft: () {
        Get.back();
        Get.off(
          () => Home(
            selectedIndex: 2,
          ),
        );
      },
      onPressedRight: onPressed,
    );
  }
}
