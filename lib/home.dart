import 'dart:async';
import 'dart:io';

import 'package:attendance_check/helpers/apis.dart';
import 'package:attendance_check/helpers/env_provider.dart';
import 'package:attendance_check/helpers/geometry.dart';
import 'package:attendance_check/helpers/qr_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? lastFetchedTime;
  bool isLoading = false;
  bool isFetchAuthCodeError = false;

  late String serverUri;
  String? model;

  Timer? _timer;
  bool _isTimerStarted = false;
  Timer? _clock;
  DateTime clock = DateTime.now();


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
        isFetchAuthCodeError = true;
      });
    } on SocketException catch (se) {
      print(se);
      setState(() {
        isLoading = false;
        model = '네트워크 연결을\n 확인해주세요.';
        lastFetchedTime = null;
        isFetchAuthCodeError = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        model = null;
        lastFetchedTime = null;
        isFetchAuthCodeError = true;
      });
    }
  }

  Future<void> refresh (BuildContext context) async {
    if(!context.mounted) return;

    Position newPosition = await determinePosition();
    EnvProvider.of(context)!.instance.setPosition(newPosition);
    await _fetchData(serverUri);
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

    _clock = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        clock = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Position? pos = EnvProvider.of(context)?.position;
    QrData qrData = QrData(latitude: pos?.latitude, longitude: pos?.longitude);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF9FAFB),
        body: OrientationBuilder(
          builder: (context, o) {
            if(o == Orientation.landscape) {
              return Padding(
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
                          padding: EdgeInsets.only(bottom: 12.0.h),
                          child: Text("출근 인증 코드", style: TextStyle(
                            fontSize: 35.sp,
                            color: const Color(0xff3666DE),
                            fontWeight: FontWeight.w600
                          ),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 24.0.h),
                          child: Text("마지막 업데이트 시각: ${lastFetchedTime != null ? DateFormat("MM월 dd일 (EEE) a hh:mm", "ko").format(lastFetchedTime!) : "-"} ", style: TextStyle(
                            color: const Color(0xff7a7a7a),
                            fontSize: 20.sp
                          ),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 24.0.h),
                          child: isLoading ? SizedBox(height: 312.h, child: Center(child: SizedBox(width: 48.w, height: 48.h, child: const CircularProgressIndicator(color: Color(0xff027BFF))))) : QrImageView(
                            data: qrData.toString(),
                            version: QrVersions.auto,
                            size: 312.sp
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.0.h),
                          child: Text("또는",  style: TextStyle(
                            color: const Color(0xff616161),
                            fontSize: 20.sp
                          ),),
                        ),
                        isLoading ? SizedBox(width: 48.w, height: 48.h, child: const CircularProgressIndicator(color: Color(0xff027BFF))) :
                        !isFetchAuthCodeError && model != null ? Text('${model!.substring(0,3)} ${model!.substring(3)}', style: TextStyle(fontSize: 63.sp, fontWeight: FontWeight.w600, letterSpacing: 10),) :
                        const Text("오류가 발생했습니다. 재발급 버튼을 눌러주세요.")
                      ],
                    ),
                  ),
                  Container(
                    width: 541.w,
                    height: 689.h,
                    padding: EdgeInsets.only(left: 71.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 134.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10.0.h),
                                child: Text('스마트운수솔루션', style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w600),),
                              ),
                              Text(DateFormat("M월 d일 (E) a hh:mm").format(clock), style: TextStyle(fontSize: 30.sp),)
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('출근하기', style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0.h),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 20.sp, color: Colors.black), // 기본 스타일
                                  children: const [
                                    TextSpan(
                                      text: '1. ', // "1." 부분
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, 
                                        color: Color(0xff0073ED),
                                      ),
                                    ),
                                    TextSpan(
                                      text: '앱에 로그인 후 ', // 일반 텍스트
                                    ),
                                    TextSpan(
                                      text: '[출퇴근관리]', // 강조 부분
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: ' -> '), // 화살표
                                    TextSpan(
                                      text: '[출근하기]', // 강조 부분
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: '를 선택하세요.'), // 일반 텍스트
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16.0.h),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 20.sp, color: Colors.black), // 기본 스타일
                                  children: const [
                                    TextSpan(
                                      text: '2. ', // "1." 부분
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, 
                                        color: Color(0xff0073ED),
                                      ),
                                    ),
                                    TextSpan(
                                      text: '(안드로이드앱 이용자) QR코드를 촬영하세요.', // 강조 부분
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(fontSize: 18.sp, color: Colors.black), // 기본 스타일
                                children: const [
                                  TextSpan(
                                    text: '    • QR 인식이 되지 않을 경우, 카메라 하단 ', // "1." 부분
                                  ),
                                  TextSpan(
                                    text: 'QR코드 인식이 안되요.', // 강조 부분
                                    style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                            ),
                            Text('      를 클릭하세요.', // Dot 추가
                              style: TextStyle(
                                fontSize: 18.sp, // 점을 더 크게 설정 가능
                            ),),
                            Padding(
                              padding: EdgeInsets.only(top: 16.0.h),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 20.sp, color: Colors.black), // 기본 스타일
                                  children: const [
                                    TextSpan(
                                      text: '3. ', // "1." 부분
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, 
                                        color: Color(0xff0073ED),
                                      ),
                                    ),
                                    TextSpan(
                                      text: '(준공영/저사양앱 이용자) 인증번호를 입력하세요.', // 강조 부분
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text('    • 인증번호 확인 후 [출근하기] 버튼을 누르세요.', // Dot 추가
                              style: TextStyle(
                                fontSize: 18.sp, // 점을 더 크게 설정 가능
                            ),),
                      
                            Container(
                              width: 541.w,
                              height: 104.h,
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xff027BFF)),
                                borderRadius: BorderRadius.circular(10.sp),
                                color:  const Color(0xffEFF6FF)
                              ),
                              margin: EdgeInsets.only(top: 24.h),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 16.0.w, right: 16.w),
                                    child: Icon(Icons.info_outline, size: 28.sp,),
                                  ),
                                  Text("출퇴근 처리가 안 될 경우\n업데이트 시각을 확인한 후 재발급 버튼을 눌러주세요.", style: TextStyle(fontSize: 18.sp, color: const Color(0xff0059C8)),)
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 24.h),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  fixedSize: Size(541.w, 64.h),
                                  backgroundColor: const Color(0xff027BFF),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.sp)
                                    )
                                  )
                                )
                                ,onPressed: () async {
                                await refresh(context);
                              }, child: Text('인증 코드 재발급', style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w600),)),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
            } else {
              return Center(child: Text("가로모드로 \n변경해주세요.", style: TextStyle(fontSize: 64.sp, fontWeight: FontWeight.w600,), textAlign: TextAlign.center,),);
            }
          } 
        ),
      ),
    );
  }
}