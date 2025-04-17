import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/beranda/controllers/location_controller.dart';
import 'package:maqdis_connect/features/player/controllers/audio_room_controller.dart';

class DaftarPesertaWidget extends StatelessWidget {
  const DaftarPesertaWidget({super.key});

  static RegExp regexEmoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  @override
  Widget build(BuildContext context) {
    final AudioRoomController audioRoomController =
        Get.find<AudioRoomController>();

    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Sliver grid untuk speaker/ustadz
                Obx(() {
                  final speakers = audioRoomController.speaker;
                  final locationController = Get.find<LocationController>();

                  return SliverToBoxAdapter(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: List.generate(speakers.length, (index) {
                        final peer = speakers[index].peer;

                        // Ambil lokasi user lain dari audioRoomController
                        final otherPosition = audioRoomController
                            .otherUsersLocation[peer.customerUserId];

                        // Hitung jarak (jika lokasi tersedia)
                        double? distance;
                        if (otherPosition != null) {
                          distance = Geolocator.distanceBetween(
                            locationController.latitude
                                .value, // Ambil dari LocationController
                            locationController.longitude
                                .value, // Ambil dari LocationController
                            otherPosition.latitude,
                            otherPosition.longitude,
                          );
                        }

                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 1 / 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 8),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: const Color(0xFFE9E9E9),
                              border: Border.all(
                                color: GlobalColors.mainColor,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  peer.name,
                                  style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 7),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          padding: const EdgeInsets.all(1.5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: const Color(0xFFD9D9D9),
                                              width: 2,
                                            ),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: getBackgroundColor(index),
                                            ),
                                            child: Center(
                                              child: Text(
                                                getAvatarTitle(peer.name),
                                                style: GoogleFonts.lato(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (distance != null)
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "${distance.toStringAsFixed(1)} m",
                                          style: GoogleFonts.lato(
                                            // fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),

                // Sliver grid untuk listener/jamaah
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      thickness: 2,
                      height: 5,
                      color: Color(0xFFE9E9E9),
                    ),
                  ),
                ),
                Obx(() {
                  final listeners = audioRoomController.listener;
                  final locationController = Get.find<LocationController>();

                  return SliverToBoxAdapter(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: List.generate(listeners.length, (index) {
                        final peer = listeners[index].peer;

                        // Ambil lokasi user lain dari audioRoomController
                        final otherPosition = audioRoomController
                            .otherUsersLocation[peer.customerUserId];

                        // Hitung jarak (jika lokasi tersedia)
                        double? distance;
                        if (otherPosition != null) {
                          distance = Geolocator.distanceBetween(
                            locationController.latitude.value,
                            locationController.longitude.value,
                            otherPosition.latitude,
                            otherPosition.longitude,
                          );
                        }
                        print('ini jarak: $distance');

                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 1 / 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 9, horizontal: 10),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: const Color(0xFFE9E9E9),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  peer.name,
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 7),
                                Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          padding: const EdgeInsets.all(1.5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: const Color(0xFFD9D9D9),
                                              width: 2,
                                            ),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: getBackgroundColor(index),
                                            ),
                                            child: Center(
                                              child: Text(
                                                getAvatarTitle(peer.name),
                                                style: GoogleFonts.lato(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (distance != null)
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "${distance.toStringAsFixed(1)} m",
                                          style: GoogleFonts.lato(
                                            // fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getAvatarTitle(String name) {
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  Color getBackgroundColor(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.teal
    ];
    return colors[index % colors.length];
  }
}
