import 'package:flutter/material.dart';
import 'package:maqdis_connect/core/common/widgets/w_local_time.dart';

class TimeDiff extends StatelessWidget {
  const TimeDiff(
      {super.key,
      required this.regionName1,
      required this.regionName2,
      required this.localTime1,
      required this.localTime2});

  final String regionName1;
  final String regionName2;
  final String localTime1;
  final String localTime2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WLocalTime(regionName: regionName1, localTime: localTime1),
        const SizedBox(width: 50),
        WLocalTime(regionName: regionName2, localTime: localTime2),
      ],
    );
  }
}
