import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_text_field.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/profile/controllers/profile_controller.dart';
import 'package:maqdis_connect/features/profile/controllers/reason_controller.dart';
import 'package:maqdis_connect/features/profile/lazy_loader/reason_loader.dart';

class ReasonFormBody extends StatefulWidget {
  ReasonFormBody({super.key, required this.profileController});

  final ProfileController profileController;
  final ReasonController reasonController = Get.put(ReasonController());

  @override
  State<ReasonFormBody> createState() => _ReasonFormBodyDartState();
}

class _ReasonFormBodyDartState extends State<ReasonFormBody> {
  @override
  void dispose() {
    widget.reasonController.selectedOption.value = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (widget.reasonController.isLoading.value) {
          return const ReasonLoader();
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apa alasan anda ingin menghapus akun?',
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: const Color(0xFFB1B1B1).withOpacity(0.25),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  widget.reasonController.reasons.map((option) {
                                final isSelected = widget.reasonController
                                        .selectedOption.value ==
                                    option.reason;

                                return GestureDetector(
                                  // onTap: () {
                                  //   widget.reasonController.selectedOption.value =
                                  //       option.reason;
                                  // },
                                  onTap: () {
                                    widget.reasonController.selectReason(
                                        option.reason,
                                        widget.profileController);
                                  },

                                  child: SizedBox(
                                    // padding:
                                    //     const EdgeInsets.symmetric(vertical: 14),
                                    height: 42,

                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected
                                                ? GlobalColors.mainColor
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: isSelected
                                                  ? GlobalColors.mainColor
                                                  : Colors.grey,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            option.reason,
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: isSelected
                                                  ? GlobalColors.mainColor
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            )),
                        Obx(() {
                          if (widget.reasonController.selectedOption.value ==
                              'Lainnya') {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 8),
                              child: WTextField(
                                horizonalPadding: 16,
                                verticalPadding: 8,
                                controller:
                                    widget.profileController.reasonController,
                                hintText: 'Tulis alasan kamu di sini',
                                maxLines: 4,
                                overrideValidator: true,
                                validator: (value) {
                                  return widget.profileController.errorMessage
                                          .value.isNotEmpty
                                      ? widget
                                          .profileController.errorMessage.value
                                      : null;
                                },
                                onChanged: (value) {
                                  widget.profileController.selectedReason
                                      .value = value;
                                  widget.profileController.clearErrorMessage();
                                },
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
