import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/users/friends/friends_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/screens/users/add_friends_qr_scan_screen.dart';
import 'package:habitr_tfg/utils/qr.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/widgets/loading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:habitr_tfg/screens/users/add_friends_qr_scan_screen.dart';
import 'package:scan/scan.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({super.key});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  ScreenshotController _controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add friends')),
      body: BlocBuilder<SelfBloc, SelfState>(
        builder: (context, state) {
          Widget _qr = LoadingSpinner();
          if (state is SelfLoaded)
            _qr = Screenshot(
              controller: _controller,
              child: QrImage(
                data: generateQRData(state.self!.id),
                size: 320.0,
                backgroundColor: Colors.white,
              ),
            );
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Your friend code'),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AspectRatio(aspectRatio: 1.0, child: _qr),
                        )),
                        Text('Share this code with whoever you want to add!'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // FIXME: Implement these
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () async {
                                XFile? f = await _captureAndSaveQRCode(
                                    saveToGallery: false);
                                if (f != null) {
                                  Share.shareXFiles([f]);
                                } else {
                                  context.showErrorSnackBar(context,
                                      message:
                                          'Please allow storage access for this to work.');
                                }
                              },
                            ),
                            IconButton(
                                icon: Icon(Icons.save),
                                onPressed: () async {
                                  XFile? f = await _captureAndSaveQRCode();
                                  if (f == null) {
                                    context.showErrorSnackBar(context,
                                        message:
                                            'Please allow storage access for this to work.');
                                  } else {
                                    context.showSnackBar(context,
                                        message: 'Saved file to ${f.path}');
                                  }
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Theme.of(context).primaryColorLight,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('To add a friend, scan their QR code below'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      // Doesn't work on emulator
                                      builder: (context) =>
                                          AddFriendsQrScanScreen()));
                            },
                            child: Text('SCAN'),
                          ),
                          TextButton(
                              onPressed: () async {
                                var status = await Permission.storage.status;
                                var result = PermissionStatus.denied;
                                if (!status.isGranted) {
                                  result = await Permission.storage.request();
                                }
                                if (status.isGranted ||
                                    result == PermissionStatus.granted) {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (image != null) {
                                    String? result =
                                        await Scan.parse(image.path);
                                    if (isValidQR(result)) {
                                      BlocProvider.of<FriendsBloc>(context).add(
                                          SendFriendRequestEvent(
                                              friendId: parseQRData(result!)));
                                    }
                                    context.showSnackBar(context,
                                        message: result ?? "Result was null");
                                  }
                                }
                              },
                              child: Text('UPLOAD'))
                        ],
                      ),
                    ],
                  ),
                ))
              ]);
        },
      ),
    );
  }

  Future<XFile?> _captureAndSaveQRCode({bool saveToGallery = true}) async {
    var status = await Permission.storage.status;
    PermissionStatus result =
        status.isGranted ? PermissionStatus.granted : PermissionStatus.denied;
    if (!status.isGranted) {
      result = await Permission.storage.request();
    }
    if (result == PermissionStatus.granted ||
        result == PermissionStatus.limited) {
      final image = await _controller.capture();
      if (image != null) {
        if (saveToGallery) {
          final result = await ImageGallerySaver.saveImage(image,
              quality: 100, name: 'qr.jpg');
          if (result['isSuccess']) {
            return Future.value(XFile(result['filePath']));
          }
        } else {
          return Future.value(XFile.fromData(image, mimeType: 'image/png'));
        }
      }
    }
    return null;
  }
}
