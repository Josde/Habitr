import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/routines/completion/routine_completion_cubit.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/models/routinesingleton.dart';
import 'package:habitr_tfg/widgets/loading_button.dart';
import 'package:habitr_tfg/widgets/timer.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/utils/constants.dart';

class StopwatchRoutineDetailScreen extends StatelessWidget {
  final Routine routine;
  const StopwatchRoutineDetailScreen({Key? key, required this.routine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(80.0),
              child: Center(
                child: Text(
                    '${routine.name}',
                    style: TextStyle(
                      fontFamily: 'Roboto Mono',
                      fontWeight: FontWeight.w200,
                      fontSize: 48,
                    )
                ),
              ),
            ),
            TimerWidget(countsUp: true, onComplete: (){}, lengthInSeconds: 0,),
            Spacer(),
            Container(
                height: 80,
                child: LoadingButton(onComplete: () {
                  RoutineCompletion rc = RoutineCompletion.now(debugUser.id, routine.id!);
                  BlocProvider.of<RoutineCompletionCubit>(context).add(rc);
                  Navigator.pop(context, true);
                })
            )],

        )
    );
  }
}
