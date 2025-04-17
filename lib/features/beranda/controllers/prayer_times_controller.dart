import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/features/beranda/controllers/location_controller.dart';
import 'package:prayers_times/prayers_times.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:intl/intl.dart';

class PrayerTimesController extends GetxController {
  final LocationController _locationController = Get.put(LocationController());
  Rx<PrayerTimes?> prayerTimes = Rx<PrayerTimes?>(null);
  RxBool isPrayerTimesLoading = false.obs;
  RxString jakartaTime = ''.obs;
  RxString mekkahTime = ''.obs;
  // ignore: unused_field
  Timer? _timer;
  Timer? _dailyResetTimer; // Timer baru buat reset setiap hari

  @override
  void onInit() {
    super.onInit();
    tzdata.initializeTimeZones();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateTimes();
    });

    ever(_locationController.currentPosition, (position) {
      if (position != null) {
        getPrayerTimes(position);
      }
    });

    if (_locationController.currentPosition.value != null) {
      getPrayerTimes(_locationController.currentPosition.value!);
    }

    scheduleDailyPrayerTimesUpdate(); // Jadwalkan reset setiap hari
  }

  void updateTimes() {
    final now = DateTime.now();
    final jakartaNow = now.toUtc().add(const Duration(hours: 7));
    jakartaTime.value = DateFormat('HH:mm').format(jakartaNow);
    final mekkahNow = now.toUtc().add(const Duration(hours: 3));
    mekkahTime.value = DateFormat('HH:mm').format(mekkahNow);
  }

  Future<void> getPrayerTimes(Position position) async {
    try {
      isPrayerTimesLoading.value = true;

      final location = tz.getLocation(
          _getTimeZoneFromLatLong(position.latitude, position.longitude));

      Coordinates coordinates =
          Coordinates(position.latitude, position.longitude);
      PrayerCalculationParameters params = PrayerCalculationMethod.karachi();
      params.madhab = PrayerMadhab.shafi;

      prayerTimes.value = PrayerTimes(
        coordinates: coordinates,
        calculationParameters: params,
        precision: true,
        locationName: location.name,
      );

      print("Jadwal Salat berhasil diperbarui!");
    } catch (e) {
      print('❌Error fetching prayer times: $e');
    } finally {
      isPrayerTimesLoading.value = false;
    }
  }

  void scheduleDailyPrayerTimesUpdate() {
    // Hitung waktu sampai jam 00:00 (tengah malam)
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    final durationUntilMidnight = nextMidnight.difference(now);

    print(
        "Menjadwalkan reset jadwal salat dalam ${durationUntilMidnight.inHours} jam...");

    _dailyResetTimer?.cancel(); // Pastikan gak ada timer lain yang jalan
    _dailyResetTimer = Timer(durationUntilMidnight, () {
      print("Reset jadwal salat...");
      if (_locationController.currentPosition.value != null) {
        getPrayerTimes(_locationController.currentPosition.value!);
      }
      scheduleDailyPrayerTimesUpdate(); // Jadwalkan ulang untuk besok
    });
  }

  String _getTimeZoneFromLatLong(double latitude, double longitude) {
    if (latitude >= -10.0 &&
        latitude <= 6.0 &&
        longitude >= 95.0 &&
        longitude <= 141.0) {
      return 'Asia/Jakarta';
    } else if (latitude >= 21.0 &&
        latitude <= 26.0 &&
        longitude >= 39.0 &&
        longitude <= 50.0) {
      return 'Asia/Riyadh';
    } else {
      return 'UTC';
    }
  }
}
