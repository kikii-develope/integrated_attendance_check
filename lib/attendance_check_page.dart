import 'package:attendance_check/footer.dart';
import 'package:attendance_check/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceCheckPage extends StatelessWidget {
  const AttendanceCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Expanded(
              flex: 2,
              child: Header()
            ),
            Expanded(
              flex: 13,
              child: Container()
            ),
            const Expanded(
              flex: 5,
              child: Footer()
            )
          ],
        ),
      ),
    );
  }
}
