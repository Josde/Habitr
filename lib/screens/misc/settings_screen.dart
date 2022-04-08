import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:habitr_tfg/blocs/theme/theme_cubit.dart';
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
            SettingsGroup(title: 'General', children: [
              buildDarkMode(context)
            ]
            ),

          ],
        ),
      )
    );
  }

  Widget buildDarkMode(BuildContext context) {
    bool value = BlocProvider.of<ThemeCubit>(context).state is ThemeDark? true : false;
    return SwitchSettingsTile(title: 'Dark mode',
                              settingKey: 'dark-mode',
                              defaultValue: value,
                              leading: Icon(Icons.dark_mode));
  }
}
