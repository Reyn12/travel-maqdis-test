import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_otp_form.dart';
import 'package:maqdis_connect/features/profile/controllers/profile_controller.dart';

class OtpFormBody extends StatelessWidget {
  const OtpFormBody({super.key, required this.profileController});

  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WOtpForm(
        otpController: profileController.otpController,
        emailAddress: profileController.email.value,
        overrideValidator: true,
        validator: (value) {
          return profileController.errorMessage.value.isNotEmpty
              ? profileController.errorMessage.value
              : null;
        },
        onChanged: (value) => profileController.clearErrorMessage(),
        onPressedResend: () => profileController.requestOTP(),
      );
    });
  }
}
