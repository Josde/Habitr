import 'package:flutter/material.dart';
//TODO: Rework this into a custom text field widget or widget builder.
InputDecorationTheme modernRoundedInput = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0)
    ),
    hintStyle: TextStyle(
      color: Colors.white60,
      fontWeight: FontWeight.bold,
    ),
    fillColor: Colors.white12,
    filled: true,
);