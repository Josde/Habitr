import 'package:flutter/material.dart';
import 'package:habitr_tfg/data/enum/ActivityType.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/models/routinesingleton.dart';
import 'package:habitr_tfg/screens/routine/instantroutinedetailscreen.dart';
import 'package:habitr_tfg/screens/routine/stopwatchroutinedetailscreen.dart';
import 'package:habitr_tfg/screens/routine/timerroutinedetailscreen.dart';

class RoutineDetailScreen extends StatelessWidget {
  int index = 0;
  RoutineDetailScreen({required this.index});

  @override
  Widget build(BuildContext context) {
    Routine rutina = RoutineSingleton().listaRutinas[index];
    switch(rutina.type) {
      case ActivityType.Instant:
        return InstantRoutineDetailScreen(index: index);
      case ActivityType.Timer:
        return TimerRoutineDetailScreen(index: index);
      case ActivityType.Stopwatch:
        return StopwatchRoutineDetailScreen(index: index);
      }
  }
}

