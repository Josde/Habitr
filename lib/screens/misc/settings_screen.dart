import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/data/models/theme_singleton.dart';
import 'package:habitr_tfg/screens/misc/debug_screen.dart';
import 'package:habitr_tfg/screens/users/login_screen.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:habitr_tfg/widgets/loading.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';

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
                  buildDebug(context),
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
    User u = BlocProvider.of<SelfBloc>(context).state.self!;
    var avatarSvg = Jdenticon.toSvg(u.id);
    return BlocBuilder<SelfBloc, SelfState>(
      builder: (context, state) {
        if (state is SelfLoaded) {
          return SimpleSettingsTile(
            title: u.name,
            subtitle: '',
            leading: SvgPicture.string(avatarSvg,
                fit: BoxFit.contain, height: 128, width: 128),
          );
        } else {
          return Center(child: LoadingSpinner());
        }
      },
    );
  }

  Widget buildLogout(BuildContext context) {
    return SimpleSettingsTile(
      title: 'Logout',
      subtitle: '', // Required by the library
      leading: Icon(Icons.logout),
      onTap: () async {
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

  Widget buildDebug(BuildContext context) {
    // TODO: Check if this works fine and SizedBox dimension 0 doesnt crash
    if (kDebugMode) {
      return IconButton(
        icon: Icon(Icons.work_rounded),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => DebugScreen())),
      );
    } else {
      return const SizedBox.square(dimension: 0.0);
    }
  }
}
