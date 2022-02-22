import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,

      ),
      body: Center(
        child: Text(
            "Settings Screen",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w300,
              letterSpacing: 2.0,
              color: Colors.grey,
            )
        ),
      ),
    );
  }
}
