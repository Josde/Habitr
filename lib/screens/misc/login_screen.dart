import 'package:flutter/material.dart';
import 'package:habitr_tfg/utils/decorators.dart';
import 'package:habitr_tfg/utils/decorators.dart';
class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Theme(
        data: ThemeData(
          inputDecorationTheme: modernRoundedInput,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icons/motivation.png'),
              Container(child: Text('Welcome to Habitr!')),
              TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'User',
                ),
              ),
              TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
              ElevatedButton(
                child: Text('Login'),
                onPressed: (){},
              ),

            ],
        ),
      ),
    );
  }
}
