import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:habitr_tfg/blocs/routines/completion/routine_completion_cubit.dart';
import 'package:habitr_tfg/blocs/routines/routines_bloc.dart';
import 'package:habitr_tfg/blocs/users/friends/friends_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/data/models/theme_singleton.dart';
import 'package:habitr_tfg/screens/misc/login_screen.dart';
import 'package:habitr_tfg/screens/routine/routine_screen.dart';
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
import 'package:habitr_tfg/data/models/theme_singleton.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'data/classes/routinecompletion.dart';

Future<void> main() async {
  DartPluginRegistrant.ensureInitialized(); // Prevents a error with flutter_settings. Requires Dart master branch (not stable) right now
  WidgetsBinding wb = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: wb);
  final String myUrl = 'https://tzkauycpwctgufjkoeds.supabase.co';
  final String myAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6a2F1eWNwd2N0Z3VmamtvZWRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDY5MDkyNTUsImV4cCI6MTk2MjQ4NTI1NX0.UBRmXGqk9oqmvL8JMoyJLEnywzsLrn1CtxQlFiGoemw';
  try {
    Hive.initFlutter('supabase_auth');
    await Supabase.initialize(url: myUrl, anonKey: myAnonKey, debug: false, localStorage: HiveLocalStorage());
    await Settings.init(cacheProvider: SharePreferenceCache());
    await initRoutines();
    tz.initializeTimeZones();
    String localTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    InitializationSettings initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
        iOS: IOSInitializationSettings(requestSoundPermission: true,
                                      requestBadgePermission: true,
                                      requestAlertPermission: true,));
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    scheduleAllRoutineNotifications(flutterLocalNotificationsPlugin);
    FlutterNativeSplash.remove();
    }
    catch (error, stacktrace) {
    print('Exception: ' + error.toString());
    print('Stacktrace: ' + stacktrace.toString());
  }
   runApp(MyApp());
}

void scheduleAllRoutineNotifications(FlutterLocalNotificationsPlugin flnp) async {
  RoutineSingleton rs = RoutineSingleton();
  int counter = 0; // For notificaation IDs
  for (Routine r in rs.listaRutinas) {
    if (r.notificationsEnabled) {
       for (int i = 0; i < r.numberOfNotifications; i++) {
      DateTime now = DateTime.now();
      tz.TZDateTime finalDateTime = tz.TZDateTime.local(now.year, now.month, now.day, r.notificationStartTime.hour, r.notificationStartTime.minute + i * 5, 0); //TODO: Change this to i*5
      print("Scheduling ${r.name} for ${finalDateTime.hour}:${finalDateTime.minute}");
      await flnp.zonedSchedule(counter++,
            r.name,
            'The hour to do ${r.name} has begun!',
            finalDateTime,
            platformChannelSpecifics,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true,
            payload: r.name,
            matchDateTimeComponents: DateTimeComponents.time,
      );
      }
    }
  }
}
// TODO: Move these to bottom_nav_bar so I can use BLoC instead of Singletons
Future<bool> initRoutines() async {
  RoutineSingleton rs = RoutineSingleton();
  var documentsDir = await getApplicationDocumentsDirectory();
  Directory routineDir = Directory(p.join(documentsDir.path, 'routines')); // TODO: Move these to constants
  Directory routineCompletionDir = Directory(p.join(documentsDir.path, 'routineCompletions'));
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
         files = await dirContents(routineCompletionDir);
        for (FileSystemEntity f in files) {
          if (f is File && f.path.endsWith('.json')) {
            // FIXME: I can't add these because I can't access BLoCs from here.
            //await (f as File).readAsString()
            //    .then((String val) => rs.listaRutinas.add(RoutineCompletion.fromJson(json.decode(val))));
            print(f.path);
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
  final ThemeSingleton myTheme = ThemeSingleton();

  Future<bool?> getLoggedInState() async {
    var supabaseBox = await Hive.openBox('supabase_authentication');
    final bool? hasLoggedIn = supabaseBox.get('hasAccessToken'); // TODO: Test this
    return hasLoggedIn;
  }
  @override
  void initState()  {
    super.initState();
    myTheme.addListener(() {setState(() {});}); // To make theme reload on startup
    final user = Supabase.instance.client.auth.user();
    FlutterNativeSplash.remove();
    var hasLoggedIn = getLoggedInState(); // This has to be a function because initState cannot be async.
    if (hasLoggedIn == null || hasLoggedIn == false) {
      childScreen = LogInScreen();
    } else {
      childScreen = BottomNavBar();
    }

  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RoutinesBloc()),
        BlocProvider(create: (context) => SelfBloc()),
        BlocProvider(create: (context) => FriendsBloc()),
        BlocProvider(create: (context) => RoutineCompletionCubit())
      ],
      child: Builder( // Para evitar problemas de contexto con el cubit de tema
        builder: (context) {
            return MaterialApp(
                        title: 'Habitr',
                        themeMode: myTheme.currentTheme(),
                        theme: lightTheme,
                        darkTheme: darkTheme,
                        home: childScreen!,);
        }
      ),
    );
  }
}



