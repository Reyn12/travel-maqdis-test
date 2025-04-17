import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maqdis_connect/core/enums/delete_account_step.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/auth/services/otp_service.dart';
import 'package:maqdis_connect/features/profile/models/user_profile_model.dart';
import 'package:maqdis_connect/features/profile/services/delete_account_services.dart';
import 'package:maqdis_connect/features/profile/services/profile_services.dart';
import 'package:maqdis_connect/features/profile/views/delete_account_success.screen.dart';

class ProfileController extends GetxController {
  var profile = UserProfileModel(
    name: '',
    email: '',
    id: '',
    role: '',
    whatsapp: '',
    statusLogin: false,
    lastLogin: '',
    photoUrl: '',
  ).obs;
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  var selectedReason = ''.obs;
  var isLoading = false.obs;
  var isDeletingAccount = false.obs;
  var currentStep = DeleteAccountStep.reason.obs;
  RxString errorMessage = ''.obs;
  var email = ''.obs;
  var imageFile = Rxn<XFile>();
  final ImagePicker _picker = ImagePicker();
  final ProfileServices profileService = ProfileServices();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    loadEmail();
  }

  // fetch profile user yang sedang login saat ini
  Future<void> fetchProfile() async {
    isLoading.value = true;
    await fetchApiProfile();
    isLoading.value = false;
  }

  // update profile user yang sedang login
  Future<void> updateProfile({
    required String name,
    required String whatsapp,
  }) async {
    try {
      isLoading.value = true;

      final updatedData = await profileService.updateProfile(name, whatsapp);

      if (updatedData != null) {
        profile.value = updatedData;
        Get.snackbar("Success", "Profile updated successfully");
      } else {
        Get.snackbar("Success", "Profile updated successfully");
      }
    } catch (e) {
      print("Error in controller while updating profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void resetStep() {
    currentStep.value = DeleteAccountStep.reason;
  }

  Future<void> loadEmail() async {
    final storedEmail = await SharedPreferencesService.getEmailUser();
    if (storedEmail != null && storedEmail.isNotEmpty) {
      email.value = storedEmail;
    } else {
      print('Email tidak ada');
    }
  }

  Future<void> fetchApiProfile() async {
    try {
      final profileService = ProfileServices();
      final fetchedProfile = await profileService.getProfile();

      if (fetchedProfile != null && fetchedProfile['data'] != null) {
        profile.value = UserProfileModel.fromJson(fetchedProfile['data']);
      } else {
        print("Profile data not found or failed to fetch.");
      }
    } catch (e) {
      print("Error fetching API profile: $e");
    }
  }

  void pickPhoto(ImageSource imageSource) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: imageSource);

      if (pickedFile != null) {
        imageFile.value = pickedFile;
        update();

        Get.snackbar("Success", "Gambar berhasil dipilih");
      } else {
        Get.snackbar("Info", "Tidak ada gambar yang dipilih");
      }
    } catch (e) {
      print("Error picking image: $e");
      Get.snackbar("Error", "Gagal mengambil gambar");
    }
  }

  void nextStep() {
    if (_validateCurrentStep()) {
      switch (currentStep.value) {
        case DeleteAccountStep.reason:
          currentStep.value = DeleteAccountStep.otpCode;
          break;
        case DeleteAccountStep.otpCode:
          break;
      }
    }
  }

  void previousStep() {
    errorMessage.value = '';

    switch (currentStep.value) {
      case DeleteAccountStep.otpCode:
        currentStep.value = DeleteAccountStep.reason;
        break;
      default:
        break;
    }
  }

  bool _validateCurrentStep() {
    errorMessage.value = '';

    switch (currentStep.value) {
      case DeleteAccountStep.reason:
        if (selectedReason.value.isEmpty) {
          errorMessage.value = 'Pilih salah satu alasan';
          Fluttertoast.showToast(msg: errorMessage.value);
          return false;
        }
        if (selectedReason.value == 'Lainnya' &&
            reasonController.text.isEmpty) {
          print(
              "reasonController.text: ${reasonController.text}"); // Cek isi teks
          errorMessage.value = 'Tuliskan alasanmu terlebih dahulu';
          return false;
        }

        break;

      case DeleteAccountStep.otpCode:
        if (otpController.text.isEmpty || !otpController.text.isNumericOnly) {
          errorMessage.value = 'OTP tidak valid';
          return false;
        }
        if (otpController.text.length != 4) {
          errorMessage.value = 'OTP harus terdiri dari 4 angka';
          return false;
        }
        break;
    }

    return true;
  }

  void clearErrorMessage() {
    if (errorMessage.value.isNotEmpty) {
      errorMessage.value = '';
      update();
    }
  }

  bool validateForm(GlobalKey<FormState> formKey) {
    // Jalankan validasi form dulu
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Jalankan validasi per step
    bool isValid = _validateCurrentStep();

    update();

    return isValid;
  }

  Future<void> requestOTP() async {
    isLoading.value = true;

    if (email.isEmpty) {
      print('Email tidak ada');
      isLoading.value = false;
      return;
    }

    /*final response = */ await OtpService.requestOtp(email.value, "delete");

    Future.delayed(const Duration(seconds: 2)).then((_) async {
      Fluttertoast.showToast(msg: "OTP Terkirim");
    });

    isLoading.value = false;
  }

  Future<bool> verifyOTP() async {
    isLoading.value = true;

    if (email.isEmpty) {
      print('Email tidak ada');
      isLoading.value = false;
      return false;
    }

    try {
      final response =
          await OtpService.verifyOtp(email.value, otpController.text);

      if (response["message"] == "OTP valid") {
        Get.snackbar("Sukses", "OTP berhasil diverifikasi");
        print("Memulai proses delete account...");
        await deleteAccount();
        print("Delete account selesai, menutup dialog...");
        return true;
      } else {
        errorMessage.value = response["message"];
        return false;
      }
    } catch (e) {
      print("Error saat verifikasi OTP: $e");
      errorMessage.value = "Terjadi kesalahan, coba lagi nanti.";
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    isDeletingAccount.value = true;
    errorMessage.value = '';

    if (email.isEmpty) {
      errorMessage.value = "Email tidak ditemukan";
      isLoading.value = false;
      return;
    }

    final response = await DeleteAccountService.deleteAccount(
        email.value, selectedReason.value);

    if (response.containsKey("error")) {
      errorMessage.value = response["error"];
      Get.snackbar("Error", response["error"]);
    } else {
      Get.snackbar("Sukses", "Akun berhasil dihapus");
      Get.offAll(() => const DeleteAccountSuccessScreen());
    }

    isDeletingAccount.value = false;
  }
}
