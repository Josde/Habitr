import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/routines/completion/bloc/routine_completion_bloc.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/widgets/loading_button.dart';
import 'package:habitr_tfg/widgets/timer.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:awesome_aurora_gradient/awesome_aurora_gradient.dart';

import '../../blocs/users/self/self_bloc.dart';

class StopwatchRoutineDetailScreen extends StatelessWidget {
  final Routine routine;
  const StopwatchRoutineDetailScreen({Key? key, required this.routine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: SizedBox.expand(
            child: Container(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(80.0),
              child: Center(
                child: Text('${routine.name}',
                    style: TextStyle(
                        fontFamily: 'Roboto Mono',
                        fontWeight: FontWeight.w300,
                        fontSize: 48,
                        color: Theme.of(context).primaryColor)),
              ),
            ),
            TimerWidget(
              countsUp: true,
              onComplete: () {},
              lengthInSeconds: 0,
            ),
            Spacer(),
            Container(
                height: 80,
                child: LoadingButton(onComplete: () {
                  User self = BlocProvider.of<SelfBloc>(context).state.self!;
                  RoutineCompletion rc =
                      RoutineCompletion.now(self.id, routine.id!);
                  BlocProvider.of<RoutineCompletionBloc>(context)
                      .add(AddRoutineCompletionEvent(rc: rc));
                  Navigator.pop(context, true);
                }))
          ],
        )).asAwesomeAurora(
                shiftX: 100, shiftY: 300, clipBehaviour: Clip.none)));
  }
}
