import 'package:attendance_check/footer.dart';
import 'package:attendance_check/header.dart';
import 'package:attendance_check/helpers/env_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttendanceCheckPage extends StatelessWidget {
  const AttendanceCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    String serverUri = EnvProvider.of(context)!.instance.getServerUri();

    print(serverUri);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Expanded(flex: 2, child: Header()),
            Expanded(flex: 13, child: Container()),
            const Expanded(flex: 5, child: Footer())
          ],
        ),
      ),
    );
  }
}
