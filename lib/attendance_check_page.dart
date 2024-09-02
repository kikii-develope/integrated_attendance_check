import 'dart:async';
import 'dart:io';

import 'package:attendance_check/footer.dart';
import 'package:attendance_check/header.dart';
import 'package:attendance_check/helpers/apis.dart';
import 'package:attendance_check/helpers/env_provider.dart';
import 'package:attendance_check/helpers/utilities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
  String? model;

  Timer? _timer;
  bool _isTimerStarted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    serverUri = EnvProvider.of(context)!.instance.getServerUri();
    super.didChangeDependencies();

    if(!_isTimerStarted) {
      _fetchData(serverUri);
      _timer = Timer.periodic(const Duration(hours: 1), (timer) {
        _fetchData(serverUri);
      });

      _isTimerStarted = true;
    }
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
      String m = await getCurrentAttendanceCode(uri);
      setState(() {
        isLoading = false;
        model = m;
        lastFetchedTime = DateTime.now();
      });
    } on ClientException catch (ce) {
      print(ce);
      setState(() {
        isLoading = false;
        model = '네트워크 연결을\n 확인해주세요.';
        lastFetchedTime = null;
      });
    } on SocketException catch (se) {
      print(se);
      setState(() {
        isLoading = false;
        model = '네트워크 연결을\n 확인해주세요.';
        lastFetchedTime = null;
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
                child: OrientationBuilder(
                  builder: (context, o) {
                    if (o == Orientation.landscape) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Padding(
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
                                ) : Text(model ?? "오류가 발생했습니다.",
                                    style: TextStyle(
                                        fontSize: 64.sp,
                                        letterSpacing: 15,
                                        fontWeight: FontWeight.w800)),
                              ),],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                  child: const Text('새로고침')),
                              Padding(
                                padding: EdgeInsets.all(16.sp),
                                child: Text(
                                  '인증번호를 동일하게 눌렀을 때\n 출/퇴근처리가 되지 않는 경우, \n 위의 새로고침 시각을 확인하시고\n 새로고침 버튼을 눌러주세요.'
                                  ,style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    } else {
                      return Column(
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
                          ) : Text(model ?? "오류가 발생했습니다.",
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
                            child: const Text('새로고침')),
                        Padding(
                          padding: EdgeInsets.all(16.sp),
                          child: Text(
                            '인증번호를 동일하게 눌렀을 때 출/퇴근처리가 되지 않는 경우, \n 위의 새로고침 시각을 확인하시고 새로고침 버튼을 눌러주세요.'
                            ,style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    );
                    }
                  }
                )),
            const Expanded(flex: 5, child: Footer())
          ],
        ),
      ),
    );
  }
}
