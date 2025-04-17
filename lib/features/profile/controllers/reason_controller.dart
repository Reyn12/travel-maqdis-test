import 'package:get/get.dart';
import 'package:maqdis_connect/features/profile/controllers/profile_controller.dart';
import 'package:maqdis_connect/features/profile/models/reason_model.dart';
import 'package:maqdis_connect/features/profile/services/reason_services.dart';

class ReasonController extends GetxController {
  final ReasonService _service = ReasonService();
  var reasons = <ReasonModel>[].obs;
  var isLoading = false.obs;
  final RxString selectedOption = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchReasons();
  }

  void fetchReasons() async {
    isLoading.value = true;
    try {
      reasons.value = await _service.fetchReasons();
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void selectReason(String reason, ProfileController profileController) {
    selectedOption.value = reason;

    if (reason != 'Lainnya') {
      profileController.selectedReason.value = reason;
    } else {
      profileController.selectedReason.value =
          profileController.reasonController.text;
    }
  }
}
