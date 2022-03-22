import 'package:flutter/material.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/models/routinesingleton.dart';
import 'package:habitr_tfg/widgets/loading_button.dart';
import 'package:habitr_tfg/widgets/timer.dart';

class StopwatchRoutineDetailScreen extends StatelessWidget {
  final Routine routine;
  const StopwatchRoutineDetailScreen({Key? key, required this.routine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                child: LoadingButton(onComplete: () {Navigator.pop(context, true);})
            )],

        )
    );
  }
}