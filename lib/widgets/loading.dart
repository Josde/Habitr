//TODO: Implement simple loading spinner
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';

class LoadingSpinner extends StatefulWidget {
  const LoadingSpinner({super.key});

  @override
  State<LoadingSpinner> createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColorDark,
              color: Theme.of(context).iconTheme.color,
              value: null),
          Text('Loading...'),
        ],
      ),
    );
  }
}
