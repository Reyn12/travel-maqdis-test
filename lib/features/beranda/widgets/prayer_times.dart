import 'package:flutter/material.dart';
import 'package:maqdis_connect/core/common/widgets/w_prayer_time.dart';

class PrayerTimes extends StatelessWidget {
  const PrayerTimes(
      {super.key,
      required this.subuh,
      required this.dzuhur,
      required this.ashar,
      required this.maghrib,
      required this.isya});

  final String subuh;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      WPrayerTime(
          prayerType: 'Subuh',
          prayerIcon: 'assets/icon/icon_subuh.png',
          prayerTime: subuh),
      WPrayerTime(
          prayerType: 'Dzuhur',
          prayerIcon: 'assets/icon/icon_dzuhur.png',
          prayerTime: dzuhur),
      WPrayerTime(
          prayerType: 'Ashar',
          prayerIcon: 'assets/icon/icon_ashar.png',
          prayerTime: ashar),
      WPrayerTime(
          prayerType: 'Maghrib',
          prayerIcon: 'assets/icon/icon_maghrib.png',
          prayerTime: maghrib),
      WPrayerTime(
          prayerType: 'Isya',
          prayerIcon: 'assets/icon/icon_isya.png',
          prayerTime: isya),
    ]);
  }
}
