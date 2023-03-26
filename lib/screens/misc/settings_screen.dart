import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/data/models/theme_singleton.dart';
import 'package:habitr_tfg/screens/misc/debug_screen.dart';
import 'package:habitr_tfg/screens/misc/login_screen.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';

import '../../utils/io.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeSingleton myTheme = ThemeSingleton();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).iconTheme.color,
        ),
        body: SafeArea(
          child: ListView(
            children: [
              SettingsGroup(
                title: 'User',
                children: [
                  buildUserOptions(context),
                  buildLogout(context),
                  IconButton(
                    icon: Icon(Icons.work_rounded),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DebugScreen())),
                  )
                ],
              ),
              SettingsGroup(title: 'General', children: [
                buildDarkMode(context),
              ]),
            ],
          ),
        ));
  }

  Widget buildUserOptions(BuildContext context) {
    User u = User
        .empty(); // Using default constructor for now, get current user from bloc next time.
    var avatarSvg = Jdenticon.toSvg(u.id);
    return SimpleSettingsTile(
      title: u.name,
      subtitle: '',
      leading: SvgPicture.string(avatarSvg,
          fit: BoxFit.contain, height: 128, width: 128),
    );
  }

  Widget buildLogout(BuildContext context) {
    return SimpleSettingsTile(
      title: 'Logout',
      subtitle: '', // Required by the library
      leading: Icon(Icons.logout),
      onTap: () async {
        await saveAll(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LogInScreen()));
        await supabase.auth.signOut();
      },
    );
  }

  Widget buildDarkMode(BuildContext context) {
    bool defValue = myTheme.isDark;
    return SwitchSettingsTile(
      title: 'Dark mode',
      settingKey: 'dark-mode',
      defaultValue: defValue,
      leading: Icon(Icons.dark_mode),
      onChange: (value) {
        myTheme.switchTheme();
        Settings.setValue('dark-mode', myTheme.isDark);
      },
    );
  }
}
