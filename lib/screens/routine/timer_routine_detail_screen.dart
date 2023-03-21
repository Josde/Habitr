import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/routines/completion/routine_completion_cubit.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/widgets/timer.dart';
import 'package:awesome_aurora_gradient/awesome_aurora_gradient.dart';

class TimerRoutineDetailScreen extends StatefulWidget {
  final Routine routine;
  const TimerRoutineDetailScreen({Key? key, required this.routine})
      : super(key: key);
  @override
  _TimerRoutineDetailScreenState createState() =>
      _TimerRoutineDetailScreenState();
}

class _TimerRoutineDetailScreenState extends State<TimerRoutineDetailScreen> {
  bool _isButtonEnabled = false;
  void buttonPress() {
    RoutineCompletion rc =
        RoutineCompletion.now(debugUser.id, widget.routine.id!);
    BlocProvider.of<RoutineCompletionCubit>(context).add(rc);
    Navigator.pop(context, true);
  }

  void onTimerComplete() {
    _isButtonEnabled = true;
    setState(
        () {}); // Calling this earlier, or updating the bool inside it makes the button state not update.
    print('timer complete');
  }

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
                child: Text('${widget.routine.name}',
                    style: TextStyle(
                        fontFamily: 'Roboto Mono',
                        fontWeight: FontWeight.w300,
                        fontSize: 48,
                        color: Theme.of(context).primaryColor)),
              ),
            ),
            TimerWidget(
              lengthInSeconds: widget.routine.timerLength,
              onComplete: () => onTimerComplete(),
              countsUp: false,
            ),
            Spacer(),
            Container(
                height: 80,
                child: IconButton(
                  icon: Icon(Icons.check),
                  color: Colors.green,
                  disabledColor: Colors.grey,
                  onPressed: _isButtonEnabled ? () => buttonPress() : null,
                ))
          ],
        )).asAwesomeAurora(
                shiftX: 100, shiftY: 300, clipBehaviour: Clip.none)));
  }
}
