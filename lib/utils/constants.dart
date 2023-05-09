import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Source: https://supabase.com/docs/guides/with-flutter#set-up-authrequiredstate
// Solo importar esto si Supabase.initialize ha sido llamado.
// es decir, no lo podemos importar hasta que se llame a main() pero si en ficheros que se importen despues de main.

final supabase = Supabase.instance.client;

extension ShowSnackBar on BuildContext {
  void showSnackBar(BuildContext context,
      {required String message, Color? backgroundColor}) {
    if (backgroundColor == null)
      backgroundColor = Theme.of(context).primaryColorDark;

    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  void showErrorSnackBar(context, {required String message}) {
    showSnackBar(context, message: message, backgroundColor: Colors.red);
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
