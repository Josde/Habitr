import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/classes/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfilescreenState createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var uuid = Uuid();
  User u = User.empty();
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
               title: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.deepPurple,
            ),
      body: Column(
        children: [
          Row( // User name and etc row
            children: [

            ],
          )
        ],
      )
    );
  }
}
