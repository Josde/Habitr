import 'package:flutter/material.dart';
import 'package:habitr_tfg/data/enum/ActivityType.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/screens/routine/instant_routine_detail_screen.dart';
import 'package:habitr_tfg/screens/routine/stopwatch_routine_detail_screen.dart';
import 'package:habitr_tfg/screens/routine/timer_routine_detail_screen.dart';

class RoutineDetailScreen extends StatelessWidget {
  final Routine routine;
  RoutineDetailScreen({required this.routine});

  @override
  Widget build(BuildContext context) {
    switch (routine.type) {
      case ActivityType.Instant:
        return InstantRoutineDetailScreen(routine: routine);
      case ActivityType.Timer:
        return TimerRoutineDetailScreen(routine: routine);
      case ActivityType.Stopwatch:
        return StopwatchRoutineDetailScreen(routine: routine);
    }
  }
}
