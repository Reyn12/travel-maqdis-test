import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_app_bar.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/core/common/widgets/w_text_button.dart';
import 'package:maqdis_connect/core/common/widgets/w_text_field.dart';
import 'package:maqdis_connect/features/profile/controllers/profile_controller.dart';
import 'package:maqdis_connect/features/profile/widgets/botom_modal_profile.dart';

class DetailEditProfileScreen extends StatefulWidget {
  const DetailEditProfileScreen({super.key, required this.profileController});

  final ProfileController profileController;

  @override
  State<DetailEditProfileScreen> createState() =>
      _DetailEditProfileScreenState();
}

class _DetailEditProfileScreenState extends State<DetailEditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController whatsappController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: widget.profileController.profile.value.name);
    whatsappController = TextEditingController(
        text: widget.profileController.profile.value.whatsapp);
    emailController = TextEditingController(
        text: widget.profileController.profile.value.email);
  }

  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: const WCustomAppBar(
        centerTitle: true,
        title: 'Edit Profil',
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(
                      () => Hero(
                        tag: 'profileImage',
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: widget
                                      .profileController.imageFile.value ==
                                  null
                              // ? const AssetImage('assets/wak_haji_mike_wazowski.jpg')
                              ? NetworkImage(widget.profileController.profile
                                  .value.photoUrl) as ImageProvider
                              : FileImage(File(widget
                                  .profileController.imageFile.value!.path)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    WTextButton(
                        buttonText: 'Ubah Foto Profil',
                        onPressed: () {
                          Get.bottomSheet(BottomModalProfile(
                              controller: widget.profileController));
                        }),
                    const SizedBox(height: 24),
                    WTextField(
                        controller: nameController,
                        label: 'Nama',
                        labelColor: const Color.fromARGB(255, 139, 139, 139),
                        hintText: 'Masukkan nama lengkap kamu'),
                    const SizedBox(height: 12),
                    WTextField(
                        controller: emailController,
                        enabled: false,
                        label: 'Email',
                        labelColor: const Color.fromARGB(255, 139, 139, 139),
                        hintText: 'Masukkan alamat email kamu'),
                    const SizedBox(height: 12),
                    WTextField(
                        controller: whatsappController,
                        label: 'Nomor WhatsApp',
                        labelColor: const Color.fromARGB(255, 139, 139, 139),
                        hintText: 'Masukkan nomor whatsapp kamu'),
                  ],
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: keyboardOpen ? 0.0 : 1.0,
              child: Visibility(
                visible: !keyboardOpen,
                child: WCustomButton(
                  onPressed: () {
                    if (nameController.text !=
                            widget.profileController.profile.value.name ||
                        whatsappController.text !=
                            widget.profileController.profile.value.whatsapp) {
                      widget.profileController
                          .updateProfile(
                        name: nameController.text,
                        whatsapp: whatsappController.text,
                      )
                          .then((_) {
                        widget.profileController.fetchProfile();
                      });
                    } else {
                      Get.snackbar(
                          'No changes', 'Your profile data is up-to-date');
                    }
                  },
                  verticalPadding: 16,
                  buttonText: 'Simpan',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
