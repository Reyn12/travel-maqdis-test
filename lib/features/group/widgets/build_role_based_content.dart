import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_button.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/group/controllers/perjalanan_controller.dart';
import 'package:maqdis_connect/features/group/lazy_loader/build_role_based_content_loader.dart';
import 'package:maqdis_connect/features/group/widgets/build_action_button.dart';

class BuildRoleBasedContent extends StatelessWidget {
  final VoidCallback onPressedBack;
  final PerjalananController perjalananController;

  const BuildRoleBasedContent({
    super.key,
    required this.perjalananController,
    required this.onPressedBack,
  });

  // final PerjalananController perjalananController;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (perjalananController.isLoading.value) {
        return const Center(child: BuildRoleBasedContentLoader());
      }

      if (perjalananController.errorMessage.isNotEmpty) {
        return Center(
          child: Text(
            'Error: ${perjalananController.errorMessage.value}',
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      if (perjalananController.perjalananList.isEmpty) {
        return const Center(child: Text('No data available'));
      }

      final statusMap = perjalananController.statusMap;

      print("Fetched Status Map: $statusMap");

      if (statusMap.isNotEmpty && statusMap.values.every((status) => status)) {
        return Center(
          child: Column(
            children: [
              Text(
                'Perjalanan Selesai',
                style:
                    GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: WCustomButton(
                  onPressed: onPressedBack,
                  buttonText: 'Kembali',
                  fontColor: Colors.black,
                  buttonColor: Colors.white,
                  border: Border.all(),
                  fontSize: 16,
                  verticalPadding: 11,
                ),
              ),
            ],
          ),
        );
      }

      return Obx(() {
        return Column(
          children: [
            CustomRadioButton(
              height: 40,
              autoWidth: true,
              elevation: 0,
              enableShape: true,
              shapeRadius: 10,
              absoluteZeroSpacing: true,
              unSelectedColor: Colors.white,
              unSelectedBorderColor: Colors.black,
              selectedColor: GlobalColors.mainColor,
              selectedBorderColor: GlobalColors.mainColor,
              disabledColor: Colors.grey.shade300,
              buttonLables: perjalananController.perjalananList
                  .map((perjalanan) =>
                      perjalanan.namaPerjalanan ?? 'Unnamed Trip')
                  .toList(),
              buttonValues: perjalananController.perjalananList
                  .map((perjalanan) => perjalanan.perjalananId)
                  .toList(),
              disabledValues: perjalananController.perjalananList
                  .where((perjalanan) =>
                      statusMap[perjalanan.namaPerjalanan?.toLowerCase()] ==
                      true)
                  .map((perjalanan) => perjalanan.perjalananId)
                  .toList(),
              buttonTextStyle: ButtonTextStyle(
                selectedColor: Colors.white,
                unSelectedColor: Colors.black,
                disabledColor: Colors.grey.shade700,
                textStyle: GoogleFonts.lato(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              margin: const EdgeInsets.all(5),
              radioButtonValue: (value) {
                if (!perjalananController.perjalananList
                    .where((perjalanan) =>
                        statusMap[perjalanan.namaPerjalanan?.toLowerCase()] ==
                        true)
                    .map((perjalanan) => perjalanan.perjalananId)
                    .toList()
                    .contains(value)) {
                  perjalananController.setSelectedJenisPerjalanan(value);
                  print(
                      'Selected Perjalanan ID: ${perjalananController.selectedJenisPerjalanan.value}');
                }
              },
            ),
            BuildActionButton(
              onPressedBack: onPressedBack,
              statusMap: statusMap,
              perjalananController: perjalananController,
            ),
          ],
        );
      });
    });
  }
}
