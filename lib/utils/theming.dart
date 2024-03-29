/// {@category Miscelaneo}
/// @nodoc
library;

import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.white,
  primaryColorDark: Colors.black12,
  disabledColor: Colors.grey,
  colorScheme: ColorScheme.light(primary: Colors.green),
  iconTheme: IconThemeData(color: Colors.green),
  primarySwatch: Colors.green,
);

ThemeData? darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey.shade900,
  primaryColor: Colors.black,
  primaryColorDark: Colors.white12,
  disabledColor: Colors.grey,
  colorScheme: ColorScheme.dark(primary: Colors.green),
  iconTheme: IconThemeData(color: Colors.green),
  primarySwatch: Colors.green,
);

TextStyle leadingText(BuildContext context) {
  return TextStyle(fontSize: 24, fontWeight: FontWeight.w500);
}

TextStyle leadFont = TextStyle(
    fontFamily: 'Roboto Mono',
    fontWeight: FontWeight.w300,
    fontSize: 48,
    shadows: [Shadow(blurRadius: 10.0)]);
