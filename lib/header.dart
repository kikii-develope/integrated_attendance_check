import 'package:attendance_check/helpers/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late Stream<DateTime> _clockStream;

  @override
  void initState() {
    _clockStream =
        Stream<DateTime>.periodic((const Duration(seconds: 15)), (count) {
      return DateTime.now();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 24.sp),
      width: Size.infinite.width,
      color: const Color(0xff142948),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: Size.infinite.height,
            padding: EdgeInsets.only(left: 8.sp),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border:
                    Border(left: BorderSide(color: Colors.white, width: 4.sp))),
            child: Text(
              '스마트\n운수솔루션',
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
          StreamBuilder<DateTime>(
              stream: _clockStream,
              builder: (context, snapshot) {
                final time = snapshot.data ?? DateTime.now();
                return Text(
                  convertDateString(time, false),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.right,
                );
              })
        ],
      ),
    );
  }
}
