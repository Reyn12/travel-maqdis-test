import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_custom_app_bar.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/group/controllers/group_list_controller.dart';
import 'package:maqdis_connect/features/group/views/responsive/group_list_desktop_screen.dart';
import 'package:maqdis_connect/features/group/views/responsive/group_list_mobile_screen.dart';

class GroupListScreenNew extends StatefulWidget {
  const GroupListScreenNew({super.key});

  @override
  State<GroupListScreenNew> createState() => _GroupListScreenNewState();
}

class _GroupListScreenNewState extends State<GroupListScreenNew> {
  final GroupListController controller = Get.put(GroupListController());
  final ScrollController _scrollController = ScrollController();
  final RxBool showAppBarTitle =
      false.obs; // Untuk menentukan apakah title muncul atau tidak

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: GlobalColors.mainColor,
        statusBarIconBrightness: Brightness.light,
      ));
    });
    _scrollController.addListener(() {
      if (_scrollController.offset > 80) {
        showAppBarTitle.value = true;
      } else {
        showAppBarTitle.value = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalColors.mainColor,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              SafeArea(
                child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverPersistentHeader(
                        pinned: true,
                        floating: false,
                        delegate: _CustomAppBarDelegate(
                          child: Obx(() => WCustomAppBar(
                                title:
                                    showAppBarTitle.value ? 'Pilih Grup' : '',
                                centerTitle: true,
                                onPressed: () => Get.back(),
                              )),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              'Pilih grup sesuai\nangkatan',
                              style: GoogleFonts.lato(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: LayoutBuilder(builder: (context, constraints) {
                    double width = constraints.maxWidth;
                    return width > 1000
                        ? GroupListDesktopScreen(controller: controller)
                        : GroupListMobileScreen(controller: controller);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Delegate buat WCustomAppBar biar tetap muncul di atas
class _CustomAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _CustomAppBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: GlobalColors.mainColor,
      child: child,
    );
  }

  @override
  double get maxExtent => kToolbarHeight;
  @override
  double get minExtent => kToolbarHeight;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
