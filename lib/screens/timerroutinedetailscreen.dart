import 'package:flutter/material.dart';
import 'package:habitr_tfg/models/routine.dart';
import 'package:habitr_tfg/models/routinesingleton.dart';
import 'package:habitr_tfg/widgets/loadingbutton.dart';

class TimerRoutineDetailScreen extends StatelessWidget {
  int index = 0;
  TimerRoutineDetailScreen({required this.index});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Routine rutina = RoutineSingleton().listaRutinas[this.index];
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
                    '${rutina.name}',
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
                child: LoadingButton(onComplete: () {Navigator.pop(context, true);})
            )],

        )
    );
  }
}
