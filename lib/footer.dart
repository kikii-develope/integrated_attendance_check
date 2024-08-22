import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  Widget DottedTitle({required int index}) {
    return Container(
      width: 40.sp,
      height: 40.sp,
      margin: EdgeInsets.only(bottom: 16.sp),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.sp),
          color: const Color(0xff142948)),
      child: Text(
        index.toString(),
        style: TextStyle(
            color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 24.sp),
      color: const Color(0xffEFEFEF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DottedTitle(index: 1),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "앱에 로그인하여\n",
                        style: TextStyle(fontSize: 20.sp, color: Colors.black, height: 1.5),
                        children: const [
                          TextSpan(
                              text: "[출퇴근관리] 의\n[출근하기]로\n",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          TextSpan(text: "들어가주세요.")
                        ]))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DottedTitle(index: 2),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "태블릿 화면 가운데 있는\n인증번호를\n",
                        style: TextStyle(fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.w600, height: 1.5),
                        children: const [
                          TextSpan(
                              text: "확인 후 입력해주세요.",
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        ]))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [DottedTitle(index: 3),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "입력한 숫자와 화면에 표시된 숫자가\n일치하는 지 확인한 다음,\n",
                        style: TextStyle(fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.w600, height: 1.5),
                        children: const [
                          TextSpan(text: "[출근하기]"),
                          TextSpan(
                              text: " 버튼을 눌러주세요..",
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        ]))
              ],
            ),
          )
        ],
      ),
    );
  }
}
