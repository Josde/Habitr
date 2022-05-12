import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../blocs/routines/completion/routine_completion_cubit.dart';
import '../blocs/routines/routines_bloc.dart';
import '../data/classes/routine.dart';
import '../data/classes/routinecompletion.dart';
import 'io.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  late Directory documentsDir;
  BuildContext context; // TODO: Recheck this, search for more BLoC info because this is kinda janky.
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