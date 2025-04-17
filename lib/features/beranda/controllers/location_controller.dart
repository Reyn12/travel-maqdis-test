import 'dart:async';

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maqdis_connect/features/player/controllers/audio_room_controller.dart';

class LocationController extends GetxController {
  Rx<Position?> currentPosition = Rx<Position?>(null);
  RxBool isLocationLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  Timer? _locationUpdateTimer;

  @override
  onInit() {
    super.onInit();
    checkAndRequestPermission();
  }

  Future<void> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        errorMessage.value = 'Izin lokasi ditolak';
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      errorMessage.value = 'Izin lokasi ditolak secara permanen';
      return;
    }

    getLocation(); // Jika izin sudah diberikan, ambil lokasi
  }

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      print("New location fetched: $position");

      currentPosition.value = position;
      print("currentPosition updated: ${currentPosition.value}");
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void startLocationUpdates({int intervalSeconds = 5}) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Periksa apakah GPS aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('GPS tidak aktif.');
      return;
    }

    // Periksa izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Izin lokasi ditolak.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Izin lokasi ditolak permanen.');
      return;
    }

    // Fungsi ambil lokasi dengan error handling
    Future<void> fetchLocation() async {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best, // Gunakan akurasi terbaik
          timeLimit: const Duration(
              seconds: 5), // 🔹 Tunggu 5 detik untuk hasil yang lebih akurat
        );

        // Cek apakah lokasi berubah jauh sebelum update
        double distanceMoved = Geolocator.distanceBetween(
          latitude.value,
          longitude.value,
          position.latitude,
          position.longitude,
        );

        if (distanceMoved > 10) {
          // 🔹 Hanya update jika pindah lebih dari 10 meter
          latitude.value = position.latitude;
          longitude.value = position.longitude;
          print("Lokasi diperbarui: ${latitude.value}, ${longitude.value}");

          final audioRoomController = Get.find<AudioRoomController>();
          audioRoomController.sendLocationToMetadata(
              latitude.value, longitude.value);

          // Update jarak ke semua user lain
          audioRoomController.otherUsersLocation.forEach((userId, pos) {
            audioRoomController.updateDistance(
                userId, pos.latitude, pos.longitude);
          });
        }
      } catch (e) {
        print("Gagal mengambil lokasi: $e");
      }
    }

    // Jalankan update pertama kali langsung
    await fetchLocation();

    // Buat timer untuk update setiap `intervalMinutes` menit
    _locationUpdateTimer?.cancel(); // Pastikan tidak ada timer lama
    _locationUpdateTimer =
        Timer.periodic(Duration(seconds: intervalSeconds), (timer) {
      fetchLocation();
    });
  }

// Fungsi untuk refresh manual
  void refreshLocation() async {
    print("Manual refresh lokasi...");
    startLocationUpdates(); // Jalankan ulang untuk update langsung
  }

  // menghentikan update lokasi
  void stopLocationUpdates() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = null;
    print("Update lokasi dihentikan.");
  }
}
