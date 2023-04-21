import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:habitr_tfg/blocs/routines/completion/bloc/routine_completion_bloc.dart';
import 'package:habitr_tfg/blocs/routines/routines_bloc.dart';
import 'package:habitr_tfg/blocs/users/friends/friends_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/data/models/theme_singleton.dart';
import 'package:habitr_tfg/screens/users/login_screen.dart';
import 'package:habitr_tfg/widgets/bottom_nav_bar.dart';
import 'package:habitr_tfg/widgets/loading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:habitr_tfg/utils/theming.dart';

Future<void> main() async {
  DartPluginRegistrant
      .ensureInitialized(); // Prevents a error with flutter_settings. Requires Dart master branch (not stable) right now
  WidgetsBinding wb = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: wb);
  final String myUrl = 'https://tzkauycpwctgufjkoeds.supabase.co';
  final String myAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6a2F1eWNwd2N0Z3VmamtvZWRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDY5MDkyNTUsImV4cCI6MTk2MjQ4NTI1NX0.UBRmXGqk9oqmvL8JMoyJLEnywzsLrn1CtxQlFiGoemw';
  try {
    Hive.initFlutter('supabase_auth');
    await Supabase.initialize(
        url: myUrl,
        anonKey: myAnonKey,
        debug: false,
        localStorage: HiveLocalStorage());
    await Settings.init(cacheProvider: SharePreferenceCache());
    FlutterNativeSplash.remove();
  } catch (error, stacktrace) {
    print('Exception: ' + error.toString());
    print('Stacktrace: ' + stacktrace.toString());
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Widget? childScreen;
  final ThemeSingleton myTheme = ThemeSingleton();

  Future<bool> getLoggedInState() async {
    bool hasLoggedIn;
    try {
      final initialSession = await SupabaseAuth.instance.initialSession;
      // Redirect users to different screens depending on the initial session
      if (initialSession != null) {
        hasLoggedIn = true;
      } else {
        hasLoggedIn = false;
      }
    } catch (e) {
      hasLoggedIn = false;
      // Handle initial auth state fetch error here
    }
    return Future.value(hasLoggedIn);
  }

  @override
  void initState() {
    super.initState();
    myTheme.isDark = Settings.getValue<bool>('dark-mode', defaultValue: false)!;
    myTheme.addListener(() {
      setState(() {});
    }); // To make theme reload on startup
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLoggedInState(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            childScreen = Center(child: LoadingSpinner());
          } else {
            bool loggedIn = snapshot.data!;
            if (!loggedIn) {
              childScreen = LogInScreen();
            } else {
              childScreen = BottomNavBar();
            }
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => RoutinesBloc()),
              BlocProvider(create: (context) => SelfBloc()),
              BlocProvider(create: (context) => FriendsBloc()),
              BlocProvider(create: (context) => RoutineCompletionBloc())
            ],
            child: Builder(
                // Para evitar problemas de contexto con el cubit de tema
                builder: (context) {
              return MaterialApp(
                title: 'Habitr',
                themeMode: myTheme.currentTheme(),
                theme: lightTheme,
                darkTheme: darkTheme,
                home: childScreen!,
              );
            }),
          );
        });
  }
}
