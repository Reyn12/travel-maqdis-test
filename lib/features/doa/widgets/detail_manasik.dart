import 'dart:io';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:maqdis_connect/core/common/views/no_data_view.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_app_bar.dart';
import 'package:maqdis_connect/core/common/widgets/w_loading_animation.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/doa/controllers/video_doa_controller.dart';
import 'package:maqdis_connect/features/doa/lazy_loader/doa_manasik_detail_loader.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailBacaanManasik extends StatefulWidget {
  DetailBacaanManasik({super.key});

  final VideoDoaController _videoDoaController = Get.find<VideoDoaController>();

  @override
  DetailBacaanManasikState createState() => DetailBacaanManasikState();
}

class DetailBacaanManasikState extends State<DetailBacaanManasik> {
  bool fullscreen = false;
  String? cachedVideoPath;
  bool isOnline = true;

  Future<void> saveCachedVideoPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cachedVideoPath', path);
  }

  Future<String?> getCachedVideoPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('cachedVideoPath');
  }

  void monitorConnectivity() {
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      setState(() {
        isOnline = connectivityResult != ConnectivityResult.none;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    // Pastikan dipanggil di luar build
    Future.delayed(Duration.zero, () {
      widget._videoDoaController.fetchVideoById();
    });

    getCachedVideoPath().then((path) async {
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          setState(() {
            cachedVideoPath = path;
          });
          print('Loaded cached video path: $path');
        } else {
          print('Cached file not found, using streaming.');
        }
      }
    });

    monitorConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: fullscreen
          ? null
          : WCustomAppBar(
              onPressed: () => Navigator.pop(context),
            ),
      body: Obx(() {
        if (widget._videoDoaController.isLoading.value) {
          return const DoaManasikDetailLoader();
        }

        final video = widget._videoDoaController.videoDetail.value;
        if (video == null) {
          return const Center(
            child: NoDataView(
              title: 'Video tidak ditemukan',
              subtitle: '',
            ),
          );
        }

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indikator "Offline Mode" jika tidak ada koneksi
                if (!isOnline && !fullscreen)
                  Container(
                    width: double.infinity,
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Center(
                      child: Text(
                        'Offline Mode',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Container(
                  color: Colors.black,
                  child: YoYoPlayer(
                    aspectRatio: 16 / 9,
                    url: isOnline
                        ? video.videoUrl
                        : cachedVideoPath ?? video.videoUrl,
                    videoStyle: VideoStyle(
                      videoDurationStyle: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      progressIndicatorColors: VideoProgressColors(
                        playedColor: GlobalColors.mainColor,
                      ),
                      qualityStyle: GoogleFonts.lato(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      forwardIcon: Icon(
                        MingCuteIcons.mgc_fast_forward_fill,
                        color: GlobalColors.mainColor,
                      ),
                      backwardIcon: Icon(
                        MingCuteIcons.mgc_fast_rewind_fill,
                        color: GlobalColors.mainColor,
                      ),
                      forwardAndBackwardBtSize: 30.0,
                      playButtonIconSize: 40.0,
                      fullScreenIconColor: GlobalColors.mainColor,
                      playIcon: Icon(
                        MingCuteIcons.mgc_play_circle_fill,
                        size: 40.0,
                        color: GlobalColors.mainColor,
                      ),
                      pauseIcon: Icon(
                        MingCuteIcons.mgc_pause_circle_fill,
                        size: 40.0,
                        color: GlobalColors.mainColor,
                      ),
                      videoQualityPadding: const EdgeInsets.all(5.0),
                    ),
                    videoLoadingStyle: VideoLoadingStyle(
                      loading: Center(
                        child: WLoadingAnimation(
                          color: GlobalColors.mainColor,
                        ),
                      ),
                    ),
                    allowCacheFile: true,
                    onCacheFileCompleted: (files) {
                      print('Cached file length ::: ${files?.length}');

                      if (files != null && files.isNotEmpty) {
                        for (var file in files) {
                          print('File path ::: ${file.path}');
                          saveCachedVideoPath(file.path);
                        }
                      }
                    },
                    onCacheFileFailed: (error) {
                      print('Cache file error ::: $error');
                    },
                    onFullScreen: (value) {
                      setState(() {
                        fullscreen = value;
                      });
                    },
                  ),
                ),
                // Sembunyikan konten di bawah video saat fullscreen
                if (!fullscreen) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Html(
                          data: video.judul,
                          style: {
                            "body": Style(
                              padding: HtmlPaddings.zero,
                              margin: Margins.zero,
                            ),
                            "h2": Style(
                              fontSize: FontSize(20),
                              fontWeight: FontWeight.w700,
                              fontFamily: GoogleFonts.lato().fontFamily,
                              padding: HtmlPaddings.zero,
                              margin: Margins.zero,
                            ),
                          },
                        ),
                        const SizedBox(height: 10),
                        Html(
                          data: video.deskripsi,
                          style: {
                            "body": Style(
                              padding: HtmlPaddings.zero,
                              margin: Margins.zero,
                            ),
                            "p": Style(
                              fontSize: FontSize(14),
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFB1B1B1),
                              fontFamily: GoogleFonts.lato().fontFamily,
                              padding: HtmlPaddings.zero,
                              margin: Margins.zero,
                            ),
                            "strong": Style(
                              fontSize: FontSize(14),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFB1B1B1),
                              fontFamily: GoogleFonts.lato().fontFamily,
                            ),
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      }),
    );
  }
}
