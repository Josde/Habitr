import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,

      ),
      body: Center(
        child: Text(
            "hello world!",
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
