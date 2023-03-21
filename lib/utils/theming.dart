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
