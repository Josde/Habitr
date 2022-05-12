import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/routines/completion/routine_completion_cubit.dart';
import 'package:habitr_tfg/blocs/routines/routines_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../data/classes/routine.dart';
import '../data/classes/routinecompletion.dart';
import 'package:path/path.dart' as p;

import 'io.dart';
Future<bool> initRoutines(BuildContext context) async {
  var documentsDir = await getApplicationDocumentsDirectory();
  Directory routineDir = Directory(p.join(documentsDir.path, 'routines'));
  RoutinesBloc rBloc = BlocProvider.of<RoutinesBloc>(context);
  bool DEBUG_OR_FIRST_TIME = !(await routineDir.exists());
  try {
    if (DEBUG_OR_FIRST_TIME) {
      await rootBundle.loadString('assets/json/routine/exercise.json')
                      .then( (String val) => rBloc.add(CreateRoutine(routine: Routine.fromJson(json.decode(val)))));
      await rootBundle.loadString('assets/json/routine/water.json')
                      .then( (String val) => rBloc.add(CreateRoutine(routine: Routine.fromJson(json.decode(val)))));
      await rootBundle.loadString('assets/json/routine/study.json')
          .then( (String val) => rBloc.add(CreateRoutine(routine: Routine.fromJson(json.decode(val)))));
    } else {
        List<FileSystemEntity> files = await dirContents(routineDir);
        for (FileSystemEntity f in files) {
          if (f is File && f.path.endsWith('.json')) {
            await (f as File).readAsString()
                .then((String val) => rBloc.add(CreateRoutine(routine: Routine.fromJson(json.decode(val)))));
          }
        }
      }
    return true;
    } catch (error, stacktrace) {
    print('Exception: ' + error.toString());
    print('Stacktrace: ' + stacktrace.toString());
    return false;
  }
}


Future<bool> initRoutineCompletions(BuildContext context) async {
  var documentsDir = await getApplicationDocumentsDirectory();
  Directory routineCompletionDir = Directory(p.join(documentsDir.path, 'routineCompletions'));
  RoutineCompletionCubit rcBloc = BlocProvider.of<RoutineCompletionCubit>(context);
  try {
    await routineCompletionDir.create();
    List<FileSystemEntity> files = await dirContents(routineCompletionDir);
    for (FileSystemEntity f in files) {
      if (f is File && f.path.endsWith('.json')) {
        await (f as File).readAsString()
            .then((String val) => rcBloc.state.routineCompletions.add(RoutineCompletion.fromJson(json.decode(val))));
      }
    }
    return true;
  } catch (error, stacktrace) {
    print('Exception: ' + error.toString());
    print('Stacktrace: ' + stacktrace.toString());
    return false;
  }
}

