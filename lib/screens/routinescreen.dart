import 'package:flutter/material.dart';
import 'package:habitr_tfg/enum/ActivityType.dart';
import 'package:habitr_tfg/models/routine.dart';
import '../utils/io.dart';
import 'dart:io';

class RoutineScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context)  {
    final List<Routine> rutinasTest = [Routine('Agua', 180, ActivityType.Instant), Routine('Ejercicio', 180, ActivityType.Timer), Routine('Estudiar', 240, ActivityType.Stopwatch)];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Routine",
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(index.toString())));
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
