import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_alert_dialog.dart';
import 'package:maqdis_connect/features/group/controllers/group_controller.dart';

class DialogExitGroup extends StatelessWidget {
  final String? namaGrup;

  const DialogExitGroup({
    super.key,
    this.namaGrup,
  });

  @override
  Widget build(BuildContext context) {
    final GroupController controller = Get.put(GroupController());

    return WAlertDialog(
      dialogTitle: 'Apakah anda yakin ingin keluar dari grup?',
      buttonTextLeft: 'Tidak',
      buttonTextRight: 'Keluar',
      fontColorL: Colors.black,
      colorLeftButton: Colors.white,
      colorRightButton: const Color(0xFFD30509),
      verticalPaddingL: 11,
      borderL: Border.all(),
      onPressedRight: () {
        Navigator.pop(context);
        keluarGrup(controller, context);
      },
    );
  }

  void keluarGrup(GroupController groupController, context) async {
    groupController.isLoading.value = true; // Tampilkan loading jika perlu

    // Memanggil exitGrup dari controller
    bool success = await groupController.exitGrup();
    if (success) {
      Get.delete<GroupController>();
// Delete controller
    }

    Get.delete<GroupController>();
  }
}
