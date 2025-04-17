import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/core/common/widgets/w_loading_animation.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/group/models/check_group_model.dart';
import 'package:maqdis_connect/features/group/controllers/group_controller.dart';
import 'package:maqdis_connect/features/group/views/group_waiting_screen.dart';

class DialogJoinGroup extends StatelessWidget {
  final List<GroupModel> data;
  final int index;

  const DialogJoinGroup({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final GroupController controller = Get.put(GroupController());

    return AlertDialog(
      elevation: 0,
      contentPadding:
          const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      actionsPadding:
          const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Kamu akan bergabung di grup',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data[index].namaGrup,
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            Obx(() => Visibility(
                  visible: controller.warningVisibleJoinGrup.value,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Gagal gabung grup',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.red),
                    ),
                  ),
                )),
            Obx(() => Visibility(
                  visible: controller.isLoading.value,
                  child: WLoadingAnimation(
                    color: GlobalColors.mainColor,
                  ),
                )),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: WCustomButton(
                  verticalPadding: 12,
                  onPressed: () {
                    if (controller.isLoading.value) {
                      controller.cancelJoinGrup();
                    }
                    Get.back();
                  },
                  buttonText: 'Batal',
                  radius: 8),
            ),
            Obx(() => Visibility(
                  visible: controller.isJoinButtonVisible.value,
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: WCustomButton(
                          verticalPadding: 12,
                          onPressed: () async {
                            final success = await controller.joinGrup(
                                data[index].grupid, data[index].namaGrup);
                            if (success) {
                              Get.back();
                              Get.to(() => const GroupWaitingScreen(
                                  /*grup: [data[index].grupid]*/));
                            }
                          },
                          buttonText: 'Gabung',
                          radius: 8),
                    ),
                  ),
                )),
          ],
        )
      ],
    );
  }
}
