import 'package:attendance_check/helpers/qr_data.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  QrData qrData = QrData();


  @override
  Widget build(BuildContext context) {

    print(qrData.toString());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: qrData.toString(),
              version: QrVersions.auto,
              size: 400
            )
          ],
        ),
      ),
    );
  }
}