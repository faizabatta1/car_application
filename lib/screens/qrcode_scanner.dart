import 'dart:convert';

import 'package:car_app/screens/kilometers.dart';
import 'package:car_app/screens/shift_selection%20screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  bool qr = false;
  bool active = false;
  MobileScannerController mobileScannerController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
        controller: mobileScannerController,
        allowDuplicates: false,
        onDetect: (barcode, args) async {
          if (barcode.rawValue == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Couldn't Scan Qr Code")));
          } else {
            final String raw = barcode.rawValue!;
            final Map data = jsonDecode(raw);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => KilometerScreen(
                selectedCarNumber: data['boardNumber'],
                selectedPrivateNumber: data['privateNumber'],
              ))
            );
          }
        }
    );
  }
}