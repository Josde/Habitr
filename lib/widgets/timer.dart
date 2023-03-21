import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habitr_tfg/utils/time.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget(
      {Key? key,
      required this.onComplete,
      required this.lengthInSeconds,
      required this.countsUp})
      : super(key: key);
  final Function onComplete;
  final int lengthInSeconds;
  final bool countsUp;
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  String _timerString = "";
  late int _currentTimer;
  late AnimationController _controller;
  late Timer timer;
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (widget.countsUp) {
          _currentTimer++;
        } else {
          _currentTimer--;
          _controller.animateTo(
              ((_currentTimer / widget.lengthInSeconds) - 1).abs(),
              duration: Duration(milliseconds: 1050));
          if (_currentTimer <= 0) {
            widget.onComplete();
            timer.cancel();
          }
        }

        _timerString = secondsToHMS(_currentTimer);
      });
    });
  }

  @override
  initState() {
    super.initState();
    _currentTimer = widget.lengthInSeconds;
    _timerString = secondsToHMS(_currentTimer);
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      setState(() {});
    });
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: SizedBox(
          height: 100.0,
          width: 100.0,
          child: CircularProgressIndicator(
            value: _controller.value,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(
            child: Text(_timerString,
                style: TextStyle(color: Theme.of(context).primaryColor))),
      ),
    ]);
  }
}
