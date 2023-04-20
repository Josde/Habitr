import 'dart:io';

import 'package:flutter/cupertino.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  late Directory documentsDir;
  BuildContext context;
  LifecycleEventHandler({required this.context});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // This function executes every time we minimize or close the app.
    //TODO: Add full save to supabase on close
    if (state == AppLifecycleState.inactive) {
      print('AppLifecycleState state: Inactive');
    }
    if (state == AppLifecycleState.resumed) {
      print('AppLifecycleState state: Resumed app');
    }
    print('AppLifecycleState state:  $state');
  }
}
