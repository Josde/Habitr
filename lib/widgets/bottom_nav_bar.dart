import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:habitr_tfg/screens/users/profile_screen.dart';
import '../blocs/routines/routines_bloc.dart';
import '../data/classes/routine.dart';
import '../data/classes/user.dart';
import '../screens/misc/home_screen.dart';
import '../screens/routine/routine_screen.dart';
import '../screens/misc/settings_screen.dart';
import '../utils/appLifecycleHandler.dart';
import '../utils/constants.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../utils/io.dart';
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}


class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  late LifecycleEventHandler leh;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    RoutineScreen(),
    ProfileScreen(user: User.empty(), isSelfProfile: true), //TODO: Update this to use Self from the Bloc when we start using the database.
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void initStateAsyncPart() async {
    await initAll(context);
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
    scheduleAllRoutineNotifications(flutterLocalNotificationsPlugin, context);
  }

  @override
  void initState() {
    leh = LifecycleEventHandler(context: context);
    WidgetsBinding.instance.addObserver(leh);
    initStateAsyncPart();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(leh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Routine',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              )],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.deepPurple[300],
            onTap: _onItemTapped,
          )
      ),
    );
  }
}

void scheduleAllRoutineNotifications(FlutterLocalNotificationsPlugin flnp, BuildContext context) async {
  int counter = 0; // For notificaation IDs
  for (Routine r in BlocProvider.of<RoutinesBloc>(context).state.routines) {
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