import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habitr_tfg/blocs/routines/completion/bloc/routine_completion_bloc.dart';
import 'package:habitr_tfg/blocs/users/achievement/achievement_bloc.dart';
import 'package:habitr_tfg/blocs/users/feed/feed_bloc.dart';
import 'package:habitr_tfg/blocs/users/friends/friends_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/screens/users/profile_screen.dart';
import 'package:habitr_tfg/utils/notifications.dart';
import '../../blocs/routines/routines_bloc.dart';
import '../../data/classes/routine.dart';
import 'home_screen.dart';
import '../routine/routine_screen.dart';
import '../../utils/constants.dart';
import 'package:timezone/timezone.dart' as tz;

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    RoutineScreen(),
    ProfileScreen.self(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    NotificationManager nm = NotificationManager();
    nm.init();
    BlocProvider.of<RoutinesBloc>(context).add(LoadRoutinesEvent());
    BlocProvider.of<SelfBloc>(context).add(LoadSelfEvent());
    BlocProvider.of<FriendsBloc>(context).add(LoadFriendsEvent());
    BlocProvider.of<FeedBloc>(context).add(LoadPostsEvent());
    BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent());
    BlocProvider.of<RoutineCompletionBloc>(context)
        .add(LoadRoutineCompletionsEvent());

    super.initState();
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
              )
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).iconTheme.color!,
            onTap: _onItemTapped,
          )),
    );
  }
}

void scheduleAllRoutineNotifications(
    FlutterLocalNotificationsPlugin flnp, BuildContext context) async {
  //FIXME: Refactor this to schedule a single routine and then run it when state is loaded, also schedule it even when app isn't open.
  int counter = 0; // For notificaation IDs
  for (Routine r in BlocProvider.of<RoutinesBloc>(context).state.routines) {
    if (r.notificationsEnabled) {
      DateTime now = DateTime.now();
      tz.TZDateTime finalDateTime = tz.TZDateTime.local(
          now.year,
          now.month,
          now.day,
          r.notificationStartTime.hour,
          r.notificationStartTime.minute,
          0);
      print(
          "Scheduling ${r.name} for ${finalDateTime.hour}:${finalDateTime.minute}");
      await flnp.zonedSchedule(
        counter++,
        r.name,
        'The hour to do ${r.name} has begun!',
        finalDateTime,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: r.name,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }
}
