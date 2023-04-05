import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class FillingBackground extends StatefulWidget {
  final Duration duration;
  final Color fill;
  final double opacity;
  const FillingBackground(
      {super.key,
      required this.duration,
      this.fill = Colors.white,
      this.opacity = 0.25});

  @override
  State<FillingBackground> createState() => _FillingBackgroundState();
}

class _FillingBackgroundState extends State<FillingBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _currentTimer = 0;
  late Timer timer;
  late Size _size;
  late Color _fill = Color.fromRGBO(
      widget.fill.red, widget.fill.green, widget.fill.blue, widget.opacity);
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _currentTimer++;
        _controller.animateTo(
            ((_currentTimer.toDouble() / widget.duration.inSeconds)),
            duration: Duration(milliseconds: 1050));
        if (_currentTimer >= widget.duration.inSeconds) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
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
    _size = window.physicalSize / window.devicePixelRatio;
    var containerHeight =
        _size.height * _currentTimer.toDouble() / widget.duration.inSeconds;
    return Container(
        alignment: Alignment.bottomCenter,
        width: _size.width,
        height: containerHeight,
        decoration: BoxDecoration(
            color: _fill, backgroundBlendMode: BlendMode.softLight));
  }
}
