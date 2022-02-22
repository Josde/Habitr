import 'package:flutter/material.dart';
import 'package:habitr_tfg/enum/ActivityType.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/models/routinesingleton.dart';
import 'package:habitr_tfg/screens/routine/instantroutinedetailscreen.dart';
import 'package:habitr_tfg/screens/routine/stopwatchroutinedetailscreen.dart';
import 'package:habitr_tfg/screens/routine/timerroutinedetailscreen.dart';
import 'package:habitr_tfg/widgets/loadingbutton.dart';

class RoutineDetailScreen extends StatelessWidget {
  int index = 0;
  RoutineDetailScreen({required this.index});

  @override
  Widget build(BuildContext context) {
    Routine rutina = RoutineSingleton().listaRutinas[index];
    switch(rutina.type) {
      case ActivityType.Instant:
        return InstantRoutineDetailScreen(index: index);
      break;
      case ActivityType.Timer:
        return TimerRoutineDetailScreen(index: index);
      break;
      case ActivityType.Stopwatch:
        return StopwatchRoutineDetailScreen(index: index);
      break;
      }
  }
}

