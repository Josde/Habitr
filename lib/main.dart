import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habitr_tfg/utils/io.dart';
import 'package:habitr_tfg/models/routine.dart';
import 'package:habitr_tfg/models/routinesingleton.dart';
import 'package:habitr_tfg/widgets/bottom_nav_bar.dart';
Future<void> main() async {
  try {
    //TODO: Implement routine parsing from JSON.
    bool routinesInitialized = await initRoutines();
    if (routinesInitialized) {
      runApp(MyApp());
    } else {
      runApp(MyApp());
      print('routines not initialized...');
    }

  } catch (error, stacktrace) {
    print('Exception: ' + error.toString());
    print('Stacktrace: ' + stacktrace.toString());
  }
}
Future<bool> initRoutines() async {
  RoutineSingleton rs = RoutineSingleton();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await rootBundle.loadString('assets/json/routine/exercise.json')
                    .then( (String val) => rs.listaRutinas.add(Routine.fromJson(json.decode(val))));
    await rootBundle.loadString('assets/json/routine/water.json')
                    .then( (String val) => rs.listaRutinas.add(Routine.fromJson(json.decode(val))));
    return true;
  } catch (error, stacktrace) {
    print('Exception: ' + error.toString());
    print('Stacktrace: ' + stacktrace.toString());
    return false;
  }
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.deepPurple,
          brightness: Brightness.dark,
          accentColor: Colors.deepPurpleAccent,
          backgroundColor: Colors.black87,
          scaffoldBackgroundColor: Colors.black87,
        ),
        home: BottomNavBar()
    );
  }
}




