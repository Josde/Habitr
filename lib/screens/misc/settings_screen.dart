import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habitr_tfg/blocs/theme/theme_cubit.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/screens/misc/login_screen.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
class SettingsScreen extends StatelessWidget {

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
        backgroundColor: Colors.deepPurple,

      ),
      body: SafeArea(
        child: ListView(
          children: [
            SettingsGroup(title: 'User', children: [
              buildUserOptions(context),
              buildLogout(context),
            ],),
            SettingsGroup(title: 'General', children: [
              buildDarkMode(context),
            ]
            ),

          ],
        ),
      )
    );
  }
  Widget buildUserOptions(BuildContext context) {
    User u = User.empty(); // Using default constructor for now, get current user from bloc next time.
    var avatarSvg = Jdenticon.toSvg(u.id);
    return SimpleSettingsTile(title: u.name,
                              subtitle: '',
                              leading: SvgPicture.string(avatarSvg, fit: BoxFit.contain, height: 128, width: 128),
    );
  }
  Widget buildLogout(BuildContext context) {
    return SimpleSettingsTile(title: 'Logout',
                              subtitle: '', // Required by the library
                              leading: Icon(Icons.logout),
                              onTap: () async {
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInScreen()));
                                              await supabase.auth.signOut();
                                              },);
  }
  Widget buildDarkMode(BuildContext context) {
    var darkModeBloc = BlocProvider.of<ThemeCubit>(context);
    bool defValue = darkModeBloc.state is ThemeDark? true : false;
    return SwitchSettingsTile(title: 'Dark mode',
                              settingKey: 'dark-mode',
                              defaultValue: defValue,
                              leading: Icon(Icons.dark_mode),
                              onChange: (value) {
                                      darkModeBloc.switchTheme();
                                      Settings.setValue('dark-mode', darkModeBloc.state == ThemeDark ? true : false);},);
  }
}
