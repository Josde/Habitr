import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scan/scan.dart';

class AddFriendsQrScanScreen extends StatefulWidget {
  const AddFriendsQrScanScreen({super.key});

  @override
  State<AddFriendsQrScanScreen> createState() => _AddFriendsQrScanScreenState();
}

class _AddFriendsQrScanScreenState extends State<AddFriendsQrScanScreen> {
  ScanController _controller = ScanController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scan QR'),
        ),
        body: ScanView(
          controller: _controller,
          onCapture: (data) => print(data),
        ));
  }
}
