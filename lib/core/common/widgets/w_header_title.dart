import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maqdis_connect/core/common/widgets/w_header_center_title.dart';
import 'package:maqdis_connect/core/common/widgets/w_header_column_title.dart';
import 'package:maqdis_connect/core/common/widgets/w_header_profile_title.dart';

class WHeaderTitle extends StatelessWidget {
  const WHeaderTitle({
    super.key,
    this.columnTitle = false,
    this.centerTitle = false,
    this.profileHeader = false,
    this.customWidget = false,
    this.headerSubtitle,
    required this.headerTitle,
    required this.widgetChild,
    this.imageHeader,
    this.widgetHeader,
    this.onPressed,
    this.backgroundImage,
    this.onTapImg,
  });

  final ImageProvider<Object>? backgroundImage;
  final String? headerSubtitle;
  final String headerTitle;
  final String? imageHeader;
  final Widget widgetChild;
  final bool columnTitle;
  final bool centerTitle;
  final bool profileHeader;
  final bool customWidget;
  final Widget? widgetHeader;
  final void Function()? onPressed;
  final void Function()? onTapImg;

  @override
  Widget build(BuildContext context) {
    RxString rxHeaderTitle = headerTitle.obs;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1 / 3.6,
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage(
                imageHeader ?? 'assets/bg_profile.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              columnTitle
                  ? WHeaderColumnTitle(
                      headerSubtitle: headerSubtitle, headerTitle: headerTitle)
                  : const SizedBox(),
              centerTitle
                  ? WHeaderCenterTitle(headerTitle: headerTitle)
                  : const SizedBox(),
              profileHeader
                  ? Expanded(
                      child: WHeaderProfileTitle(
                        onTapImg: onTapImg,
                        backgroundImage: backgroundImage,
                        headerTitle: rxHeaderTitle,
                        onPressed: onPressed,
                      ),
                    )
                  : const SizedBox(),
              customWidget
                  ? widgetHeader ?? const SizedBox()
                  : const SizedBox(),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: widgetChild,
          ),
        ),
      ],
    );
  }
}
