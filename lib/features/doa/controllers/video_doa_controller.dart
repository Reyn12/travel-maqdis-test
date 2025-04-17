import 'package:get/get.dart';
import 'package:maqdis_connect/features/doa/models/video_doa_model.dart';
import 'package:maqdis_connect/features/doa/services/video_doa_service.dart';

class VideoDoaController extends GetxController {
  final VideoDoaService _videoService = VideoDoaService();

  var videoList = <VideoDoaModel>[].obs;
  var videoDetail = Rxn<VideoDoaModel>();
  var isLoading = false.obs;
  var videoId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  /// Mengambil daftar video doa dari layanan API.
  /// Jika berhasil, data akan disimpan dalam `videoList`.
  Future<void> fetchVideos() async {
    try {
      isLoading.value =
          true; // Set status loading ke true sebelum mengambil data
      final videos = await _videoService.getVideoDoa();
      if (videos != null) {
        videoList.assignAll(
            videos); // Menyimpan daftar video ke dalam variabel reaktif
      }
    } catch (e) {
      print(
          'Error fetching videos: $e'); // Menangani error jika terjadi kegagalan
    } finally {
      isLoading.value = false; // Set status loading ke false setelah selesai
    }
  }

  /// Mengambil detail video doa berdasarkan ID yang disimpan di `videoId`.
  /// Jika berhasil, data akan disimpan dalam `videoDetail`.
  Future<void> fetchVideoById() async {
    try {
      isLoading.value =
          true; // Set status loading ke true sebelum mengambil data
      final video = await _videoService.getVideoById(videoId.value);
      if (video != null) {
        videoDetail.value =
            video; // Menyimpan detail video ke dalam variabel reaktif
      }
    } catch (e) {
      print(
          'Error fetching video detail: $e'); // Menangani error jika terjadi kegagalan
    } finally {
      isLoading.value = false; // Set status loading ke false setelah selesai
    }
  }
}
