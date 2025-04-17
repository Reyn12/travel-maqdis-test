import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_header_title.dart';
import 'package:maqdis_connect/core/common/widgets/w_enum_loading_anim.dart';
import 'package:maqdis_connect/features/auth/controllers/logout_controller.dart';
import 'package:maqdis_connect/features/auth/views/imports/login_screen.dart';
import 'package:maqdis_connect/features/profile/controllers/profile_controller.dart';
import 'package:maqdis_connect/features/profile/views/delete_account_screen.dart';
import 'package:maqdis_connect/features/profile/views/detail_edit_profile_screen.dart';
import 'package:maqdis_connect/features/profile/widgets/build_info_row.dart';
import 'package:maqdis_connect/features/profile/widgets/dialog_profile.dart';
import 'package:maqdis_connect/features/profile/widgets/profile_build_info.dart';

class ProfileScreenNew extends StatelessWidget {
  ProfileScreenNew({super.key});

  final ProfileController profileController = Get.put(ProfileController());
  final LogoutController logoutController = Get.find<LogoutController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          WHeaderTitle(
            onTapImg: () {
              Get.dialog(
                Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: InteractiveViewer(
                      panEnabled: true,
                      scaleEnabled: true,
                      minScale: 0.5,
                      maxScale: 4,
                      child: profileController.imageFile.value == null
                          // ? Image.asset('assets/wak_haji_mike_wazowski.jpg')
                          ? Image.network(
                              profileController.profile.value.photoUrl)
                          : Image.file(
                              File(profileController.imageFile.value!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                    ),
                  ),
                ),
              );
            },
            profileHeader: true,
            backgroundImage: profileController.imageFile.value == null
                // ? const AssetImage('assets/wak_haji_mike_wazowski.jpg')
                ? NetworkImage(profileController.profile.value.photoUrl)
                    as ImageProvider
                : FileImage(File(profileController.imageFile.value!.path)),
            headerTitle: profileController.profile.value.name,
            onPressed: () => Get.to(() =>
                DetailEditProfileScreen(profileController: profileController)),
            widgetChild: Column(
              children: [
                ProfileBuildInfo(
                  paddingBottom: 12,
                  children: [
                    BuildInfoRow(
                        leadingImg: 'assets/email_icon.png',
                        label: 'Email',
                        value: profileController.profile.value.email),
                    const SizedBox(height: 16),
                    BuildInfoRow(
                        leadingImg: 'assets/icon_whatsapp.png',
                        label: 'No WhatsApp',
                        value: profileController.profile.value.whatsapp),
                    const SizedBox(height: 16),
                    BuildInfoRow(
                      leadingImg: 'assets/icon_info.png',
                      label: 'Bergabung',
                      value: profileController.profile.value.lastLogin
                          .substring(0, 10),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const DeleteAccountScreen());
                  },
                  child: const ProfileBuildInfo(
                    paddingTop: 0,
                    paddingBottom: 12,
                    cardBackground: false,
                    children: [
                      BuildInfoRow(
                        leadingImg: 'assets/icon_trash.png',
                        label: 'Hapus akun',
                        labelColor: Color(0xFFD30509),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Get.dialog(
                      DialogProfile(
                        dialogTitle: 'Apakah anda yakin ingin keluar?',
                        buttonTextRight: 'Keluar',
                        onPressedRight: () async {
                          Get.back();
                          await logoutController.logout();
                          await Get.offAll(() => const LoginScreen());
                        },
                      ),
                    );
                  },
                  child: const ProfileBuildInfo(
                    paddingTop: 0,
                    cardBackground: false,
                    children: [
                      BuildInfoRow(
                        leadingImg: 'assets/icon_exit.png',
                        label: 'Keluar akun',
                        labelColor: Color(0xFFD30509),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            if (profileController.isLoading.value) {
              return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: WEnumLoadingAnim()));
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
