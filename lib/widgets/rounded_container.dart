import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;
  const RoundedContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.child,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Theme.of(context).primaryColorDark,
      ),
    );
  }
}
