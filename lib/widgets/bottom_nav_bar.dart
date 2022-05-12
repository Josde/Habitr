import 'package:flutter/material.dart';
import 'package:habitr_tfg/screens/users/profile_screen.dart';
import '../data/classes/user.dart';
import '../screens/misc/home_screen.dart';
import '../screens/routine/routine_screen.dart';
import '../screens/misc/settings_screen.dart';
import '../utils/appLifecycleHandler.dart';
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

  @override
  void initState() {
    leh = LifecycleEventHandler(context: context);
    WidgetsBinding.instance.addObserver(leh);
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

