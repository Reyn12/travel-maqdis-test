// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, file_names, prefer_interpolation_to_compose_strings, avoid_print

import 'package:flutter/material.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/player/controllers/audio_room_controller.dart';
import 'package:maqdis_connect/features/player/widgets/bottom_sheet_perjalanan.dart';

class ModalBottomSheetPerjalanan extends StatefulWidget {
  const ModalBottomSheetPerjalanan(
      {super.key, required this.audioRoomController});

  final AudioRoomController audioRoomController;

  @override
  State<ModalBottomSheetPerjalanan> createState() =>
      _ModalBottomSheetPerjalananState();
}

class _ModalBottomSheetPerjalananState
    extends State<ModalBottomSheetPerjalanan> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            isDismissible: false,
            enableDrag: false,
            builder: (BuildContext context) {
              return BottomSheetPerjalanan(
                audioRoomController: widget.audioRoomController,
              );
            });
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            border: Border.all(
                color: GlobalColors.mainColor,
                width: 1,
                style: BorderStyle.solid)),
        child: Column(
          children: [
            Icon(
              Icons.keyboard_arrow_up_outlined,
              color: GlobalColors.mainColor,
              size: 20,
            ),
            Text(
              'Progres Perjalananmu',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
