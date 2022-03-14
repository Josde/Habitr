import 'package:flutter/material.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/models/routinesingleton.dart';
import 'package:habitr_tfg/widgets/loadingbutton.dart';

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
                child: LoadingButton(onComplete: () {Navigator.pop(context, true);})
            )],

        )
    );
  }
}
