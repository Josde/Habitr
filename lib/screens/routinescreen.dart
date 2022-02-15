import 'package:flutter/material.dart';
import 'package:habitr_tfg/enum/ActivityType.dart';
import 'package:habitr_tfg/models/routine.dart';
import 'package:habitr_tfg/models/routinesingleton.dart';
import 'package:habitr_tfg/screens/editroutinescreen.dart';
import '../utils/io.dart';
import 'dart:io';

class RoutineScreen extends StatelessWidget {
  RoutineSingleton rs = RoutineSingleton();
  @override
  Widget build(BuildContext context)  {
    final List<Routine> rutinasTest = rs.listaRutinas;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Routines",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,

      ),
      body: Center(
        child:
          ListView.builder(
            itemCount: rutinasTest.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                    height: 50,
                    color: Colors.white24,
                    child: Center(child: Text('${rutinasTest[index].name}', style: TextStyle(color: Colors.white)))
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EditRoutineScreen()));
                }
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          backgroundColor: Colors.purple[300],
          child: const Icon(Icons.add),
        )
      );
  }
}
