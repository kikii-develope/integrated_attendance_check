import 'package:attendance_check/attendance_check_page.dart';
import 'package:attendance_check/helpers/env.dart';
import 'package:attendance_check/helpers/env_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(EnvProvider(buildType: BuildType.dev, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        print(orientation);
        return ScreenUtilInit(
            designSize: orientation == Orientation.portrait ?  const Size(768, 1024) : const Size(1200, 800),
            builder: (_, child) {
              return MaterialApp(
                  title: 'smartTS_attendance_check',
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                        seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                  home: const AttendanceCheckPage());
            });
      }
    );
  }
}
