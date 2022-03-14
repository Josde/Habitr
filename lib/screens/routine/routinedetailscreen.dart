import 'package:flutter/material.dart';
import 'package:habitr_tfg/data/enum/ActivityType.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/models/routinesingleton.dart';
import 'package:habitr_tfg/screens/routine/instantroutinedetailscreen.dart';
import 'package:habitr_tfg/screens/routine/stopwatchroutinedetailscreen.dart';
import 'package:habitr_tfg/screens/routine/timerroutinedetailscreen.dart';

class RoutineDetailScreen extends StatelessWidget {
  Routine routine;
  RoutineDetailScreen({required this.routine});

  @override
  Widget build(BuildContext context) {
    switch(routine.type) {
      case ActivityType.Instant:
        return InstantRoutineDetailScreen(routine: routine);
      case ActivityType.Timer:
        return TimerRoutineDetailScreen(routine: routine);
      case ActivityType.Stopwatch:
        return StopwatchRoutineDetailScreen(routine: routine);
      }
  }
}

