import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habitr_tfg/data/classes/user.dart' as u;
// Source: https://supabase.com/docs/guides/with-flutter#set-up-authrequiredstate
// Solo importar esto si Supabase.initialize ha sido llamado.
// es decir, no lo podemos importar hasta que se llame a main() pero si en ficheros que se importen despues de main.

final supabase = Supabase.instance.client;
ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.white,
  primaryColorDark: Colors.black12,
  disabledColor: Colors.grey,
  colorScheme: ColorScheme.light(),
  iconTheme: IconThemeData(color: Colors.purple),
);

ThemeData? darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey.shade900,
  primaryColor: Colors.black,
  primaryColorDark: Colors.white12,
  disabledColor: Colors.grey,
  colorScheme: ColorScheme.dark(),
  iconTheme: IconThemeData(color: Colors.purple),
);
extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

// Notifications

const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('habit-reminders', 'Routine reminders',
        channelDescription: 'Routine notifications, as configured by the user',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

u.User debugUser = u.User.debug('Debug');

