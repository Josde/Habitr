import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../blocs/routines/completion/routine_completion_cubit.dart';
import '../data/classes/routine.dart';
import '../data/classes/routinecompletion.dart';
import '../data/models/routinesingleton.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  late Directory documentsDir;
  BuildContext context; // TODO: Recheck this, search for more BLoC info because this is very janky.
  LifecycleEventHandler({required this.context});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // This function executes every time we minimize or close the app.
    var documentsDir = await getApplicationDocumentsDirectory();
    Directory routineDir = Directory(p.join(documentsDir.path, 'routines'));
    Directory completionDir = Directory(p.join(documentsDir.path, 'routineCompletions'));
    if (state == AppLifecycleState.inactive) {
      await routineDir.create();
      await completionDir.create();
      for (Routine r in RoutineSingleton().listaRutinas) {
        File routineFile = File(p.join(routineDir.path, '${r.id}.json'));
        await routineFile.create();
        print('Written to routine file ${routineFile.path}');
        routineFile.writeAsString(json.encode(r));
      }
      for (RoutineCompletion rc in BlocProvider
          .of<RoutineCompletionCubit>(context)
          .state
          .routineCompletions) {
        File routineCompletionFile = File(
            p.join(completionDir.path, '${rc.userId}-${rc.routineId}-${rc.time.millisecondsSinceEpoch}.json'));
        await routineCompletionFile.create();
        print('Written to routine file ${routineCompletionFile.path}');
        routineCompletionFile.writeAsString(json.encode(rc));
      }
    }
    if (state == AppLifecycleState.resumed) {
      print('AppLifecycleState state: Resumed app');
    }
    print('AppLifecycleState state:  $state');
  }
}