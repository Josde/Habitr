/// {@category Vista}
/// {@category GestionSocial}
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/users/friends/friends_bloc.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/utils/qr.dart';
import 'package:scan/scan.dart';

class AddFriendsQrScanScreen extends StatefulWidget {
  const AddFriendsQrScanScreen({super.key});

  @override
  State<AddFriendsQrScanScreen> createState() => _AddFriendsQrScanScreenState();
}

class _AddFriendsQrScanScreenState extends State<AddFriendsQrScanScreen>
    with AutomaticKeepAliveClientMixin {
  ScanController _controller = ScanController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Scan QR'),
          backgroundColor: Theme.of(context).iconTheme.color,
        ),
        body: ScanView(
          controller: _controller,
          onCapture: (data) {
            print(data);
            if (isValidQR(data)) {
              var parsedData = parseQRData(data);
              context.showSnackBar(context,
                  message: 'Sent friend request to $parsedData');
              BlocProvider.of<FriendsBloc>(context)
                  .add(SendFriendRequestEvent(friendId: parsedData));
              Navigator.pop(context);
            }
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
