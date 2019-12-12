//import 'package:barcode_scan/barcode_scan.dart';
//import 'package:flutter/services.dart';
//import 'package:qr_scanner_generator/model/DRData.dart';
//
//class Scanner {
//  String barCode ;
//
//  Future scan(QRData barCode) async {
//    try {
//      this.barCode  = await BarcodeScanner.scan();
//      setState(() => this.barcode = barcode);
//
////      this.barCode = await barcode;
////      print(this.barCode);
//    } on PlatformException catch (e) {
//      if (e.code == BarcodeScanner.CameraAccessDenied) {
//        this.barCode = 'The user did not grant the camera permission!';
//      } else {
//        this.barCode = 'Unknown error: $e';
//      }
//    } on FormatException {
//      this.barCode =
//          'null (User returned using the "back"-button before scanning anything. Result)';
//    } catch (e) {
//      this.barCode = 'Unknown error: $e';
//    }
//  }
//}
