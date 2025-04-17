import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_enum_loading_anim.dart';
import 'package:maqdis_connect/core/utils/global.colors.dart';
import 'package:maqdis_connect/features/auth/controllers/logout_controller.dart';
import 'package:maqdis_connect/features/beranda/views/beranda_screen_new.dart';
import 'package:maqdis_connect/features/riwayat_perjalanan/views/perjalanan_screen_new.dart';
import 'package:maqdis_connect/features/profile/views/profile_screen_new.dart';

class Home extends StatefulWidget {
  Home({super.key, this.selectedIndex = 0});

  final int selectedIndex;

  final LogoutController logoutController = Get.put(LogoutController());

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int myCurrentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myCurrentIndex = widget.selectedIndex;
  }

  List pages = [
    const BerandaScreenNew(),
    PerjalananScreenNew(),
    ProfileScreenNew(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          bottomNavigationBar: Container(
            height: 100,
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 18,
                spreadRadius: -16,
                blurStyle: BlurStyle.normal,
              )
            ]),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                selectedItemColor: GlobalColors.mainColor,
                unselectedItemColor: Colors.grey,
                currentIndex: myCurrentIndex,
                type: BottomNavigationBarType.fixed,
                elevation: 8,
                iconSize: 20,
                selectedFontSize: 11,
                unselectedFontSize: 10,
                unselectedLabelStyle: GoogleFonts.lato(
                  fontWeight: FontWeight.w400,
                ),
                selectedLabelStyle: GoogleFonts.lato(
                  fontWeight: FontWeight.w500,
                ),
                onTap: (index) {
                  setState(() {
                    myCurrentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 5), // Menambah gap di sini
                      child: Image.asset(
                        'assets/icon/icon_home.png',
                        scale: 2,
                        color: myCurrentIndex == 0
                            ? GlobalColors.mainColor
                            : Colors.grey,
                      ),
                    ),
                    label: 'Beranda',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Image.asset(
                        'assets/icon/icon_travel.png',
                        scale: 2,
                        color: myCurrentIndex == 1
                            ? GlobalColors.mainColor
                            : Colors.grey,
                      ),
                    ),
                    label: 'Riwayat',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Image.asset(
                        'assets/icon/icon_profile.png',
                        scale: 2,
                        color: myCurrentIndex == 2
                            ? GlobalColors.mainColor
                            : Colors.grey,
                      ),
                    ),
                    label: 'Profil',
                  ),
                ],
              ),
            ),
          ),
          body: pages[myCurrentIndex],
        ),
        Obx(() {
          if (widget.logoutController.isLogout.value) {
            return Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: WEnumLoadingAnim()));
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
