import 'package:flutter/material.dart';

void rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }
  (context as Element).visitChildren(rebuild);
}

void rebuildEntireWidget(BuildContext context, String path) {
  Navigator.popAndPushNamed(context, path);
}