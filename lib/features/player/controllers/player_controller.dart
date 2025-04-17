import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:maqdis_connect/features/auth/services/local/shared_preferences_service.dart';
import 'package:maqdis_connect/features/room/controllers/progress_doa_controller.dart';
import 'package:maqdis_connect/features/room/services/local/room_data.dart';
import 'package:maqdis_connect/features/room/services/progress_doa_service.dart';

class PlayerControllerTesting extends GetxController {
  final ProgressDoaController _progressDoaController =
      Get.put(ProgressDoaController());
  final ProgressDoaService _progressDoaService = ProgressDoaService();
  var listpage = <Map<String, dynamic>>[].obs;
  var currentIndex = 0.obs;
  var audioPlayer = AudioPlayer();
  var arabicFontSize = 24.0.obs;
  var translationFontSize = 18.0.obs;
  var currentPosition = Duration.zero.obs;
  var isPlaying = false.obs;
  var isLoading = false.obs;
  var isFinished = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listener untuk posisi audio
    audioPlayer.positionStream.listen((position) {
      currentPosition.value = position;
    });

    // Listener untuk status player
    audioPlayer.playerStateStream.listen((playerState) {
      isPlaying.value = playerState.playing;
      isLoading.value =
          playerState.processingState == ProcessingState.loading ||
              playerState.processingState == ProcessingState.buffering;

      // Jika audio selesai, ubah isPlaying menjadi false dan reset posisi
      if (playerState.processingState == ProcessingState.completed) {
        isPlaying.value = false;
        currentPosition.value = Duration.zero;
      }
    });
  }

  @override
  void onClose() {
    print("Controller dihapus!");
    stopAudio();
    super.onClose();
  }

  Future<void> loadJsonData() async {
    final perjalananId =
        await RoomDataSharedPreferenceService.getCurrentPerjalananId();
    final userRole = await SharedPreferencesService.getRole();

    if (perjalananId!.isEmpty) {
      print('perjalanan id tidak ditemukan');
    }

    if (userRole!.isEmpty) {
      print('userRole tidak ditemukan');
    }

    try {
      final jsonData =
          await _progressDoaService.fetchDoaByPerjalananId(perjalananId);

      if (jsonData.isEmpty) {
        print("⚠ Tidak ada data doa ditemukan.");
        return;
      }

      print('response doa: $jsonData');

      listpage.value = jsonData
          .map((item) => {
                "doaId": item["doaid"],
                "judul_doa": item["judul_doa"],
                "audio": item["link_audio"],
                "ayat": item["ayat"]
              })
          .toList();

      if (listpage.isNotEmpty) {
        currentIndex.value = 0;
        if (userRole == 'ustadz') {
          await startProgressForCurrentDoa();
        }
        await loadAudio();
      }

      print("Data Loaded: ${listpage.length} items");
    } catch (e) {
      print("Error loading API data: $e");
    }
  }

  Future<void> startProgressForCurrentDoa() async {
    print('listpage: $listpage');
    print('currentIndex: ${currentIndex.value}');
    print('current doa: ${listpage[currentIndex.value]['doaId']}');

    try {
      if (listpage.isNotEmpty) {
        String doaId = listpage[currentIndex.value]["doaId"];
        print('ini doa id: $doaId');

        await _progressDoaController.postProgressDoa(doaId);
        print('✅ Progress Doa Posted for Doa ID: $doaId');
      }
    } catch (e) {
      print('❌ Error posting Progress Doa: $e');
      Fluttertoast.showToast(msg: "Failed to start progress doa.");
    }
  }

  String convertGoogleDriveUrl(String url) {
    final regex = RegExp(r"/file/d/([^/]+)/");
    final match = regex.firstMatch(url);
    if (match != null) {
      return "https://drive.google.com/uc?export=download&id=${match.group(1)}";
    }
    return url;
  }

  Future<void> loadAudio() async {
    try {
      isLoading.value = true;
      String? audioUrl =
          listpage[currentIndex.value]['audio']; // Ambil URL dari API

      if (audioUrl == null || audioUrl.isEmpty) {
        print("Error: Audio URL is null or empty");
        isLoading.value = false;
        return;
      }

      if (audioUrl.contains("drive.google.com")) {
        print("Google Drive link detected. Converting...");
        audioUrl = convertGoogleDriveUrl(audioUrl);
      }

      print("Final audio URL: $audioUrl");

      await audioPlayer.setUrl(audioUrl);
      // audioPlayer.play();

      isLoading.value = false;
    } catch (e) {
      print("Error loading audio: $e");
      isLoading.value = false;
    }
  }

  void playAudio() async {
    if (audioPlayer.processingState == ProcessingState.idle ||
        audioPlayer.processingState == ProcessingState.completed) {
      await loadAudio(); // Load ulang jika audio belum di-set atau sudah selesai
    }

    if (audioPlayer.duration != null) {
      await audioPlayer.seek(currentPosition.value);
    }

    isPlaying.value = true; // Paksa UI berubah dulu
    await audioPlayer.play();
  }

  void stopAudio() async {
    await audioPlayer.stop(); // Hentikan audio sepenuhnya
    currentPosition.value = Duration.zero; // Reset posisi ke awal
    isPlaying.value = false; // Update state UI
  }

  void pauseAudio() async {
    currentPosition.value = audioPlayer.position;
    await audioPlayer.pause();
    isPlaying.value = false;
  }

  void seekAudio(Duration position) async {
    await audioPlayer.seek(position);
    currentPosition.value = position;
  }

  // void nextPage() async {
  //   if (currentIndex.value < listpage.length - 1) {
  //     currentIndex.value++;
  //     currentPosition.value = Duration.zero;
  //     await loadAudio();
  //     playAudio();
  //   }
  // }

  void nextPage() async {
    if (currentIndex.value < listpage.length - 1) {
      isLoading.value = true; // Hindari spam next

      try {
        // Pindah ke halaman berikutnya lebih dulu
        currentIndex.value++;

        // Ambil progressDoaId dari response sebelumnya
        String? progressDoaId =
            _progressDoaController.progressData['progress_doaid'];
        print('ini progress doa id untuk NextPage : $progressDoaId');

        if (progressDoaId != null) {
          // Update progress untuk doa yang sedang berjalan
          await _progressDoaController.updateProgressDoa(progressDoaId);
        }

        // **Pastikan postProgressDoa selesai sebelum lanjut ke audio**
        await _progressDoaController
            .postProgressDoa(listpage[currentIndex.value]["doaId"]);

        // Reset posisi audio
        currentPosition.value = Duration.zero;

        // Load dan play audio
        await loadAudio();
        // playAudio();
      } catch (e) {
        print("❌ Error di nextPage: $e");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void previousPage() async {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      currentPosition.value = Duration.zero;
      await loadAudio();
      // playAudio();
    }
  }

  void finishPage() async {
    print("🔚 Menyelesaikan semua doa...");

    // Set isFinished lebih dulu agar UI listener langsung update
    isFinished.value = true;
    stopAudio();

    // Ambil progressDoaId dari response sebelumnya
    String? progressDoaId =
        _progressDoaController.progressData['progress_doaid'];
    print('Progress Doa ID untuk Finish Page: $progressDoaId');

    if (progressDoaId != null) {
      try {
        // Update progress untuk doa yang sedang berjalan
        await _progressDoaController.updateProgressDoa(progressDoaId);
        print("✅ Progress doa berhasil diperbarui.");
      } catch (e) {
        print("❌ Error update progress doa: $e");
      }
    } else {
      print("⚠ Tidak ada progressDoaId ditemukan.");
    }
  }

  void callbackUser() async {
    currentPosition.value = Duration.zero;
    await loadAudio();
    playAudio();
  }
}
