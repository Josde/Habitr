///@nodoc
library;

import 'package:flutter/material.dart';

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
      alignment: Alignment.center,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColorDark,
                color: Theme.of(context).iconTheme.color,
                value: null),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Loading...'),
            ),
          ],
        ),
      ),
    );
  }
}
