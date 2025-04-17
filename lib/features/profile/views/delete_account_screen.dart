import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/navbar/home.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_app_bar.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/core/common/widgets/w_enum_loading_anim.dart';
import 'package:maqdis_connect/core/enums/delete_account_step.dart';
import 'package:maqdis_connect/core/enums/loading_animation.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/profile/controllers/profile_controller.dart';
import 'package:maqdis_connect/features/profile/widgets/dialog_profile.dart';
import 'package:maqdis_connect/features/profile/widgets/otp_form_body.dart';
import 'package:maqdis_connect/features/profile/widgets/reason_form_body.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final ProfileController _controller = Get.find<ProfileController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: WCustomAppBar(
            centerTitle: true,
            title: 'Hapus Akun',
            onPressed: () {
              if (_controller.currentStep.value != DeleteAccountStep.reason) {
                _controller.previousStep();
              } else {
                _controller.resetStep();
                _controller.reasonController.clear();
                Get.off(() => Home(selectedIndex: 2));
              }
            },
          ),
          body: PopScope(
              canPop: false,
              onPopInvoked: (didPop) {
                if (_controller.currentStep.value != DeleteAccountStep.reason) {
                  _controller.previousStep();
                } else {
                  _controller.resetStep();
                  _controller.reasonController.clear();
                  Get.off(() => Home(selectedIndex: 2));
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                child: SizedBox(
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Obx(() {
                          switch (_controller.currentStep.value) {
                            case DeleteAccountStep.reason:
                              return Form(
                                  key: formKey,
                                  child: ReasonFormBody(
                                      profileController: _controller));
                            case DeleteAccountStep.otpCode:
                              return Form(
                                key: formKey,
                                child: OtpFormBody(
                                  profileController: _controller,
                                ),
                              );
                          }
                        }),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: keyboardOpen ? 0.0 : 1.0,
                        child: Visibility(
                          visible: !keyboardOpen,
                          child: Obx(() {
                            return WCustomButton(
                              onPressed: () async {
                                if (_controller.validateForm(formKey)) {
                                  if (_controller.currentStep.value !=
                                      DeleteAccountStep.otpCode) {
                                    _controller.nextStep();
                                    await _controller.requestOTP();
                                  } else {
                                    Get.dialog(DialogProfile(
                                      dialogTitle:
                                          'Apakah anda yakin ingin menghapus akun secara permanen?',
                                      buttonTextRight: 'Hapus',
                                      onPressedLeft: () {
                                        Get.back();
                                        _controller.resetStep();
                                        _controller.otpController.clear();
                                        _controller.reasonController.clear();
                                        Get.off(() => Home(selectedIndex: 2));
                                      },
                                      onPressedRight: () async {
                                        Get.back();
                                        await _controller.verifyOTP();
                                      },
                                    ));
                                  }
                                } else {
                                  print(
                                      "Validasi gagal, tetap di halaman sekarang");
                                }
                              },
                              buttonColor: _controller.currentStep.value ==
                                      DeleteAccountStep.otpCode
                                  ? const Color(0xFFD30509)
                                  : _controller.selectedReason.value.isEmpty
                                      ? const Color(0xFFB1B1B1)
                                      : GlobalColors.mainColor,
                              verticalPadding: 16,
                              buttonText: _controller.currentStep.value ==
                                      DeleteAccountStep.otpCode
                                  ? 'Hapus akun'
                                  : 'Lanjut',
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
        Obx(() {
          if (_controller.isDeletingAccount.value) {
            return Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: WEnumLoadingAnim(
                  animation: LoadingAnimation.delete,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        })
      ],
    );
  }
}
