import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/views/no_data_view.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_app_bar.dart';
import 'package:maqdis_connect/core/common/widgets/w_fold_shape.dart';
import 'package:maqdis_connect/features/doa/controllers/video_doa_controller.dart';
import 'package:maqdis_connect/features/doa/lazy_loader/doa_manasik_loader.dart';
import 'package:maqdis_connect/features/doa/widgets/detail_manasik.dart';

class ManasikScreen extends StatefulWidget {
  ManasikScreen({super.key});

  final VideoDoaController _videoDoaController = Get.put(VideoDoaController());

  @override
  State<ManasikScreen> createState() => _ManasikScreenState();
}

class _ManasikScreenState extends State<ManasikScreen> {
  final List<LinearGradient> gradients = [
    const LinearGradient(
      colors: [Color(0xFFF58634), Color(0xFFFF9242)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF319F43), Color(0xFF4CC15F)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      transform: GradientRotation(
          121.18 * (3.141592653589793 / 180)), // Convert degrees to radians
    ),
    const LinearGradient(
      colors: [Color(0xFF43A5D9), Color(0xFF1D8CC6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      transform: GradientRotation(
          121.18 * (3.141592653589793 / 180)), // Convert degrees to radians
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: WCustomAppBar(
        onPressed: () => Navigator.pop(context),
        centerTitle: true,
        title: 'Video Manasik',
      ),
      body: Obx(() {
        if (widget._videoDoaController.isLoading.value) {
          return const DoaManasikLoader();
        }

        if (widget._videoDoaController.videoList.isEmpty) {
          return const Center(
            child: NoDataView(
              title: 'Tidak ada data',
              subtitle: 'Video manasik tidak dapat ditemukan.',
            ),
          );
        }

        return SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(
                    'Pilih yang sesuai dengan\nkebutuhan anda',
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: AnimationLimiter(
                    child: MasonryGridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      physics: const ClampingScrollPhysics(),
                      itemCount: widget._videoDoaController.videoList.length,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        final video =
                            widget._videoDoaController.videoList[index];
                        final gradient = gradients[index % gradients.length];

                        return AnimationConfiguration.staggeredGrid(
                          columnCount: 2,
                          position: index,
                          delay: const Duration(milliseconds: 300),
                          child: ScaleAnimation(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.fastLinearToSlowEaseIn,
                            scale: 1.5,
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () {
                                  widget._videoDoaController.videoId.value =
                                      video.videoId;
                                  Get.to(
                                    () => DetailBacaanManasik(),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: gradient,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 84,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 27, 27, 27),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      video.thumbnail),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            Text(
                                              video.judul.replaceAll(
                                                  RegExp(r'<.*?>'), ''),
                                              style: GoogleFonts.lato(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [
                                                Text(
                                                  'Mulai Disini',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 30),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: SizedBox(
                                          height: 140,
                                          child: GradientShapeWidget(
                                            variant: (index % 3) + 1,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 20,
                                        left: 6,
                                        child: FoldShape(index: '${index + 1}'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

final List<String> imageList = [
  'assets/upin_cijambe.png',
  'assets/wak_haji_mike_wazowski.jpg'
];

class GradientShapeWidget extends StatelessWidget {
  final int variant; // Pilih variasi (1, 2, atau 3)
  final Size size;

  const GradientShapeWidget(
      {super.key, required this.variant, this.size = const Size(300, 100)});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: _GradientShapePainter(variant),
    );
  }
}

class _GradientShapePainter extends CustomPainter {
  final int variant;

  _GradientShapePainter(this.variant);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    Path path;

    if (variant == 1) {
      // Variasi pertama
      paint.shader = LinearGradient(
        colors: [
          const Color(0xFFF8F9FD).withAlpha(65),
          const Color(0xFFE9E9E9).withAlpha(2)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      path = Path()
        ..moveTo(0, size.height * 0.7)
        ..quadraticBezierTo(size.width * 0.25, size.height * 0.5,
            size.width * 0.5, size.height * 0.8)
        ..quadraticBezierTo(
            size.width * 0.75, size.height * 1.1, size.width, size.height * 0.8)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else if (variant == 2) {
      // Variasi kedua
      paint.shader = LinearGradient(
        colors: [
          const Color(0xFFE9E9E9).withAlpha(2),
          const Color(0xFFF8F9FD).withAlpha(65),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      path = Path()
        ..moveTo(0, size.height * 0.8)
        ..quadraticBezierTo(size.width * 0.3, size.height * 0.6,
            size.width * 0.5, size.height * 0.7)
        ..quadraticBezierTo(
            size.width * 0.8, size.height * 0.9, size.width, size.height * 0.6)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else {
      // Variasi ketiga
      paint.shader = LinearGradient(
        colors: [
          const Color(0xFFF8F9FD).withAlpha(65),
          const Color(0xFFE9E9E9).withAlpha(2)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      path = Path()
        ..moveTo(0, size.height * 0.8)
        ..quadraticBezierTo(size.width * 0.2, size.height * 0.4,
            size.width * 0.5, size.height * 0.6)
        ..quadraticBezierTo(
            size.width * 0.7, size.height * 0.8, size.width, size.height * 0.5)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
