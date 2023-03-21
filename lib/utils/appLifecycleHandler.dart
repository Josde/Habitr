import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'io.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  late Directory documentsDir;
  BuildContext
      context; // TODO: Recheck this, search for more BLoC info because this is kinda janky.
  LifecycleEventHandler({required this.context});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // This function executes every time we minimize or close the app.
    if (state == AppLifecycleState.inactive) {
      await saveAll(context);
    }
    if (state == AppLifecycleState.resumed) {
      print('AppLifecycleState state: Resumed app');
    }
    print('AppLifecycleState state:  $state');
  }
}
