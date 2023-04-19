import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/routines/routines_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../data/classes/routine.dart';
import '../data/classes/routinecompletion.dart';
import 'package:path/path.dart' as p;

Future<List<FileSystemEntity>> dirContents(Directory dir) async {
  final List<FileSystemEntity> entities = await dir.list().toList();
  return entities;
}

Future<List<bool>> initAll(BuildContext context) async {
  List<bool> ret = [];
  ret.add(await initRoutines(context));
  return ret;
}

Future<bool> initRoutines(BuildContext context) async {
  var documentsDir = await getApplicationDocumentsDirectory();
  Directory routineDir = Directory(p.join(documentsDir.path, 'routines'));
  RoutinesBloc rBloc = BlocProvider.of<RoutinesBloc>(context);
  bool DEBUG_OR_FIRST_TIME = !(await routineDir.exists());
  try {
    if (DEBUG_OR_FIRST_TIME) {
      await rootBundle.loadString('assets/json/routine/exercise.json').then(
          (String val) => rBloc.add(
              CreateRoutineEvent(routine: Routine.fromJson(json.decode(val)))));
      await rootBundle.loadString('assets/json/routine/water.json').then(
          (String val) => rBloc.add(
              CreateRoutineEvent(routine: Routine.fromJson(json.decode(val)))));
      await rootBundle.loadString('assets/json/routine/study.json').then(
          (String val) => rBloc.add(
              CreateRoutineEvent(routine: Routine.fromJson(json.decode(val)))));
    } else {
      List<FileSystemEntity> files = await dirContents(routineDir);
      for (FileSystemEntity f in files) {
        if (f is File && f.path.endsWith('.json')) {
          await f.readAsString().then((String val) => rBloc.add(
              CreateRoutineEvent(routine: Routine.fromJson(json.decode(val)))));
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

Future<List<bool>> saveAll(BuildContext context) async {
  List<bool> ret = [];
  ret.add(await saveRoutines(context));

  return ret;
}

Future<bool> saveRoutines(BuildContext context) async {
  var documentsDir = await getApplicationDocumentsDirectory();
  Directory routineDir = Directory(p.join(documentsDir.path, 'routines'));
  try {
    await routineDir.create();
    for (Routine r in BlocProvider.of<RoutinesBloc>(context).state.routines) {
      File routineFile = File(p.join(routineDir.path, '${r.id}.json'));
      await routineFile.create();
      print('Written to routine file ${routineFile.path}');
      routineFile.writeAsString(json.encode(r));
    }
    return true;
  } catch (error, stacktrace) {
    print('Exception: ' + error.toString());
    print('Stacktrace: ' + stacktrace.toString());
    return false;
  }
}

Future<bool> deleteRoutine(Routine r) async {
  var documentsDir = await getApplicationDocumentsDirectory();
  Directory routineDir = Directory(p.join(documentsDir.path, 'routines'));
  try {
    await routineDir.create();
    File routineFile = File(p.join(routineDir.path, '${r.id}.json'));
    await routineFile.delete();
    print('Deleted routine file ${routineFile.path}');
    return true;
  } catch (error, stacktrace) {
    print('Exception: ' + error.toString());
    print('Stacktrace: ' + stacktrace.toString());
    return false;
  }
}
