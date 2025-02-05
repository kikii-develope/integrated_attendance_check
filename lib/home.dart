import 'package:attendance_check/helpers/env_provider.dart';
import 'package:attendance_check/helpers/qr_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});



  @override
  Widget build(BuildContext context) {
    Position? pos = EnvProvider.of(context)?.position;
    QrData qrData = QrData(latitude: pos?.latitude, longitude: pos?.longitude);

    return Scaffold(
      backgroundColor: Color(0xffF9FAFB),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 55.0.w, vertical: 38.0.w),
        child: Row(
          children: [
            Container(
              width: 545.w,
              height: 689.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.sp),
                color: Colors.white
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0.h),
                    child: Text("출근 인증 코드", style: TextStyle(
                      fontSize: 35.sp,
                      color: const Color(0xff3666DE),
                      fontWeight: FontWeight.w600
                    ),),
                  ),
                  Text("마지막 업데이트 시각: ${DateFormat("MM월 mm일 (EEE) a hh:mm", "ko").format(DateTime.now())}", style: const TextStyle(
                    color: Color(0xff7a7a7a)
                  ),),
                  QrImageView(
                    data: qrData.toString(),
                    version: QrVersions.auto,
                    size: 312.sp
                  ),
                  const Text("또는"),
                  const Text("123 456")
                ],
              ),
            ),
            Container(
              width: 541.w,
              height: 689.h,
              child: Column(
                children: [
                  SizedBox(
                    height: 104.h,
                    child: const Column(
                      children: [
                        Text('스마트운수솔루션'),
                        Text("2월 4일")
                      ],
                    ),
                  ),
                  Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}