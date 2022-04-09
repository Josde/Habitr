import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:habitr_tfg/blocs/routines/routines_bloc.dart';
import 'package:habitr_tfg/blocs/users/friends/friends_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/screens/misc/login_screen.dart';
import 'package:habitr_tfg/utils/io.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/models/routinesingleton.dart';
import 'package:habitr_tfg/widgets/bottom_nav_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:habitr_tfg/utils/constants.dart';

import 'blocs/theme/theme_cubit.dart';

Future<void> main() async {
  DartPluginRegistrant.ensureInitialized(); // Prevents a error with flutter_settings. Requires Dart master branch (not stable) right now
  WidgetsBinding wb = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: wb);
  final String myUrl = 'https://tzkauycpwctgufjkoeds.supabase.co';
  final String myAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6a2F1eWNwd2N0Z3VmamtvZWRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDY5MDkyNTUsImV4cCI6MTk2MjQ4NTI1NX0.UBRmXGqk9oqmvL8JMoyJLEnywzsLrn1CtxQlFiGoemw';
  runApp(MyApp());
  try {
    //TODO: Implement routine parsing from JSON.
    Hive.initFlutter('supabase_auth');
    await Supabase.initialize(url: myUrl, anonKey: myAnonKey, debug: false, localStorage: HiveLocalStorage());
    await Settings.init(cacheProvider: SharePreferenceCache());
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
  Future<bool> getLoggedInState() async {
    var supabaseBox = await Hive.openBox('supabase_authentication'); // TODO: Implementar un backend de SharedPreferences.
    final bool hasLoggedIn = supabaseBox.get('hasAccessToken');
    return hasLoggedIn;
  }
  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance!.addObserver(LifecycleEventHandler());
    final user = Supabase.instance.client.auth.user();
    FlutterNativeSplash.remove();
    var hasLoggedIn = getLoggedInState(); // This has to be a function because initState cannot be async.
    if (hasLoggedIn == false) {
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
        BlocProvider(create: (context) => RoutinesBloc()),
        BlocProvider(create: (context) => ThemeCubit(), lazy: false),
        BlocProvider(create: (context) => SelfBloc()),
        BlocProvider(create: (context) => FriendsBloc())
      ],
      child: Builder( // Para evitar problemas de contexto con el cubit de tema
        builder: (context) {
          return MaterialApp(
              title: 'Habitr',
              theme: BlocProvider.of<ThemeCubit>(context).state.theme!, // Change this to be related to BLoC on startup.
              home: childScreen!,);
        }
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



