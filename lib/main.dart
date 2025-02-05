import 'package:attendance_check/attendance_check_page.dart';
import 'package:attendance_check/helpers/env.dart';
import 'package:attendance_check/helpers/env_provider.dart';
import 'package:attendance_check/helpers/geometry.dart';
import 'package:attendance_check/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main () async {

  
  WidgetsFlutterBinding.ensureInitialized();
  
  // 상태바, 하단바 숨기는 옵션
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  Intl.defaultLocale = 'ko';
  await initializeDateFormatting();

  Position position = await determinePosition();

  runApp(EnvProvider(buildType: BuildType.prod, position: position, child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (kDebugMode) {
          print(orientation);
        }
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
                  home: HomePage());
            });
      }
    );
  }
}
