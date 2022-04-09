import 'package:flutter/material.dart';

import 'feed_screen.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget? child;
  final GameScreen game = GameScreen();
  final FeedScreen feed = FeedScreen();
  @override
  void initState() {
    child = game;
    super.initState();
  }
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
        child: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            setState(() {
              if (child == game) {
                child = feed;
              } else {
                child = game;
              }
            }
            );
          },
          child: child
        )
      ),
    );
  }
}
