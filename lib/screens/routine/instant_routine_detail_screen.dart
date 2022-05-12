import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/routines/completion/routine_completion_cubit.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/widgets/loading_button.dart';

import '../../utils/constants.dart';

class InstantRoutineDetailScreen extends StatelessWidget {
  final Routine routine;
  const InstantRoutineDetailScreen({Key? key, required this.routine}) : super(key: key);

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
            Spacer(),
            Container(
                height: 80,
                child: LoadingButton(onComplete: () {
                  //User self = BlocProvider.of<SelfBloc>().state.self;
                  RoutineCompletion rc = RoutineCompletion.now(debugUser.id, routine.id!);
                  BlocProvider.of<RoutineCompletionCubit>(context).add(rc);
                  Navigator.pop(context, true);
                })
            )],

        )
    );
  }
}
