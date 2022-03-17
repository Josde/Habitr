import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/routines/routines_bloc.dart';
import 'package:habitr_tfg/screens/misc/login_screen.dart';
import 'package:habitr_tfg/utils/io.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/models/routinesingleton.dart';
import 'package:habitr_tfg/widgets/bottom_nav_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:habitr_tfg/utils/constants.dart';

Future<void> main() async {
  WidgetsBinding wb = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: wb);
  final String myUrl = 'https://tzkauycpwctgufjkoeds.supabase.co';
  final String myAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6a2F1eWNwd2N0Z3VmamtvZWRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDY5MDkyNTUsImV4cCI6MTk2MjQ4NTI1NX0.UBRmXGqk9oqmvL8JMoyJLEnywzsLrn1CtxQlFiGoemw';
  runApp(MyApp());
  try {
    //TODO: Implement routine parsing from JSON.
    await Supabase.initialize(url: myUrl, anonKey: myAnonKey);
    bool routinesInitialized = await initRoutines();
    FlutterNativeSplash.remove();
    }
    catch (error, stacktrace) {
    print('Exception: ' + error.toString());
    print('Stacktrace: ' + stacktrace.toString());
  }
}
Future<bool> initRoutines() async {
  RoutineSingleton rs = RoutineSingleton();
  var documentsDir = await getApplicationDocumentsDirectory();
  Directory routineDir = Directory(p.join(documentsDir.path, 'routines'));
  bool DEBUG_OR_FIRST_TIME = !(await routineDir.exists());
  try {
    if (DEBUG_OR_FIRST_TIME) {
      await rootBundle.loadString('assets/json/routine/exercise.json')
                      .then( (String val) => rs.listaRutinas.add(Routine.fromJson(json.decode(val))));
      await rootBundle.loadString('assets/json/routine/water.json')
                      .then( (String val) => rs.listaRutinas.add(Routine.fromJson(json.decode(val))));
      await rootBundle.loadString('assets/json/routine/study.json')
          .then( (String val) => rs.listaRutinas.add(Routine.fromJson(json.decode(val))));
    } else {
        List<FileSystemEntity> files = await dirContents(routineDir);
        for (FileSystemEntity f in files) {
          if (f is File && f.path.endsWith('.json')) {
            await (f as File).readAsString()
                .then((String val) => rs.listaRutinas.add(Routine.fromJson(json.decode(val))));
          }
        }
      }

    return true;
  } catch (error, stacktrace) {
    print('Exception: ' + error.toString());
    print('Stacktrace: ' + stacktrace.toString());
    return false;
  }
}
class MyApp extends StatefulWidget{
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Widget? childScreen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(LifecycleEventHandler());
    final user = supabase.auth.user();
    FlutterNativeSplash.remove();
    if (user == null) {
      childScreen = LogInScreen();
    } else {
      childScreen = BottomNavBar();
    }

  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(LifecycleEventHandler());
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RoutinesBloc())
      ],
      child: MaterialApp(
          title: 'Habitr',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            brightness: Brightness.dark,
            backgroundColor: Colors.black87,
            scaffoldBackgroundColor: Colors.black87,
          ),
          home: childScreen!,
      ),
    );
  }
}


class LifecycleEventHandler extends WidgetsBindingObserver {
  late Directory documentsDir;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    var documentsDir = await getApplicationDocumentsDirectory();
    Directory routineDir = Directory(p.join(documentsDir.path, 'routines'));
    if(state == AppLifecycleState.inactive) {
      await routineDir.create();
      for (Routine r in RoutineSingleton().listaRutinas) {
        File routineFile = File(p.join(routineDir.path, '${r.id}.json'));
        await routineFile.create();
        print('Written to routine file ${routineFile.path}');
        routineFile.writeAsString(json.encode(r));

      }
    }
    if(state == AppLifecycleState.resumed) {
      print('AppLifecycleState state: Resumed app');
    }
    print('AppLifecycleState state:  $state');
  }
}



