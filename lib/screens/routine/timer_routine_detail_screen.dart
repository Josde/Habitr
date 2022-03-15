import 'package:flutter/material.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/models/routinesingleton.dart';
import 'package:habitr_tfg/widgets/timer.dart';

class TimerRoutineDetailScreen extends StatefulWidget {
  final Routine routine;
  const TimerRoutineDetailScreen({Key? key, required this.routine}) : super(key: key);
  @override
  _TimerRoutineDetailScreenState createState() => _TimerRoutineDetailScreenState();
}

class _TimerRoutineDetailScreenState extends State<TimerRoutineDetailScreen> {
  bool _isButtonEnabled = false;
  void buttonPress() {
    Navigator.pop(context, true);
  }
  void onTimerComplete() {
    _isButtonEnabled = true;
    setState(() {}); // Calling this earlier, or updating the bool inside it makes the button state not update.
    print('timer complete');
  }
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
                    '${widget.routine.name}',
                    style: TextStyle(
                      fontFamily: 'Roboto Mono',
                      fontWeight: FontWeight.w200,
                      fontSize: 48,
                    )
                ),
              ),
            ),
            TimerWidget(lengthInSeconds: widget.routine.timerLength,
                        onComplete: () => onTimerComplete(),
                        countsUp: false,
            ),
            Spacer(),
            Container(
                height: 80,
                child: IconButton(icon: Icon(Icons.check),
                                  color: Colors.green,
                                  disabledColor: Colors.grey,
                                  onPressed: _isButtonEnabled ? () => buttonPress() : null,
                                  )
            )],

        )
    );
  }
}
