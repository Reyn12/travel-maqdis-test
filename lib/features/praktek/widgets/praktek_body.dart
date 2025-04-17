import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maqdis_connect/core/common/widgets/w_praktek_card.dart';
import 'package:maqdis_connect/core/enums/platform_enum.dart';

class PraktekBody extends StatelessWidget {
  const PraktekBody({
    super.key,
    this.onTapGrup,
    this.onTapMandiri,
    this.platform = PlatformEnum.mobile,
  });

  final VoidCallback? onTapGrup;
  final VoidCallback? onTapMandiri;
  final PlatformEnum platform;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Pilih yang sesuai dengan\nanda',
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            platform != PlatformEnum.mobile
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: WPraktekCard(
                          cardImage: 'card_grup.png',
                          leadingImage: 'assets/crowd.png',
                          title: 'Grup',
                          subtitle: 'Khusus untuk kamu sebagai jamaah MAQDIS',
                          onTap: onTapGrup,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: WPraktekCard(
                          isDisabled: true,
                          cardImage: 'card_mandiri.png',
                          leadingImage: 'assets/hajj.png',
                          title: 'Mandiri',
                          subtitle:
                              'Untuk kamu yang ingin umroh secara mandiri',
                          onTap: onTapMandiri,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: WPraktekCard(
                          isDisabled: true,
                          cardImage: 'card_latihan.png',
                          leadingImage: 'assets/practice.png',
                          title: 'Latihan',
                          subtitle: 'Sebelum berangkat umroh coba latihan dulu',
                          onTap: () {},
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      WPraktekCard(
                        cardImage: 'card_grup.png',
                        leadingImage: 'assets/crowd.png',
                        title: 'Grup',
                        subtitle: 'Khusus untuk kamu sebagai jamaah MAQDIS',
                        onTap: onTapGrup,
                      ),
                      const SizedBox(height: 12),
                      WPraktekCard(
                        isDisabled: true,
                        cardImage: 'card_mandiri.png',
                        leadingImage: 'assets/hajj.png',
                        title: 'Mandiri',
                        subtitle: 'Untuk kamu yang ingin umroh secara mandiri',
                        onTap: onTapMandiri,
                      ),
                      const SizedBox(height: 12),
                      WPraktekCard(
                        isDisabled: true,
                        cardImage: 'card_latihan.png',
                        leadingImage: 'assets/practice.png',
                        title: 'Latihan',
                        subtitle: 'Sebelum berangkat umroh coba latihan dulu',
                        onTap: () {},
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
