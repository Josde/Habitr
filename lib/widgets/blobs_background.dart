import 'dart:ui';

import 'package:flutter/material.dart';

class BlobsBackground extends StatelessWidget {
  const BlobsBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [Colors.red, Colors.yellow, Colors.deepPurple[900]!];
    return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: Container(
            color: Colors.transparent,
            child: Container(
                decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: colors),
            ))));
  }
}
