import 'dart:async';

import 'package:attendance_check/footer.dart';
import 'package:attendance_check/header.dart';
import 'package:attendance_check/helpers/apis.dart';
import 'package:attendance_check/helpers/env_provider.dart';
import 'package:attendance_check/helpers/utilities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import 'helpers/attendance_code_model.dart';

class AttendanceCheckPage extends StatefulWidget {
  const AttendanceCheckPage({super.key});

  @override
  State<AttendanceCheckPage> createState() => _AttendanceCheckPageState();
}

class _AttendanceCheckPageState extends State<AttendanceCheckPage> {
  DateTime? lastFetchedTime;
  bool isLoading = false;

  late String serverUri;
  AttendanceCodeModel? model;

  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    serverUri = EnvProvider.of(context)!.instance.getServerUri();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _fetchData(serverUri);
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData(String uri) async {
    try {
      setState(() {
        isLoading = true;
      });
      AttendanceCodeModel m = await getCurrentAttendanceCode(uri);
      setState(() {
        isLoading = false;
        model = m;
        lastFetchedTime = DateTime.now();
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        model = null;
        lastFetchedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Expanded(flex: 2, child: Header()),
            Expanded(
                flex: 13,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.sp),
                      child: Text(
                        '출근 인증 코드',
                        style: TextStyle(
                            fontSize: 32.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.sp),
                      child: Text(
                        "마지막 업데이트 시각: ${lastFetchedTime != null ? convertDateString(lastFetchedTime!, true) : '출근코드 불러온 이력이 없습니다.'}",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 40.sp),
                      child: isLoading ? const CircularProgressIndicator(
                        color: Color(0xff142948),
                      ) : Text(model?.code ?? "오류가 발생했습니다.",
                          style: TextStyle(
                              fontSize: 64.sp,
                              letterSpacing: 15,
                              fontWeight: FontWeight.w800)),
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xff142948),
                            fixedSize: Size(232.sp, 48.sp),
                            textStyle: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4.sp))
                          )
                        ),
                        onPressed: () async {
                          await _fetchData(serverUri);
                        },
                        child: const Text('새로고침'))
                  ],
                )),
            const Expanded(flex: 5, child: Footer())
          ],
        ),
      ),
    );
  }
}
