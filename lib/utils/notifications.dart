import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habitr_tfg/utils/constants.dart';
import '../data/classes/routine.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  int id = 0;
  ValueNotifier<bool> hasInit = ValueNotifier(false);
  Queue<Routine> routines = Queue();
  Map<int, int> notifications = Map();
  FlutterLocalNotificationsPlugin flnp = FlutterLocalNotificationsPlugin();
  InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
      iOS: DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      ));

  void init() async {
    tz.initializeTimeZones();
    await this.flnp.initialize(this.initializationSettings);
    this.hasInit.value = true;
  }

  static NotificationManager _singleton = NotificationManager._internal();

  factory NotificationManager() {
    return _singleton;
  }

  NotificationManager._internal() {
    this.hasInit = ValueNotifier(false);
    this.hasInit.addListener(() {
      // Once hasInit is true, initiate processing the queue.
      if (this.hasInit.value) {
        this.processQueue();
      }
    });
  }

  void addToQueue(Routine r, {bool process = true}) {
    routines.add(r);
    if (process && this.hasInit.value) {
      this.processQueue();
    }
  }

  void processQueue() async {
    if (this.hasInit.value) {
      for (Routine r in this.routines) {
        var notificationId = await this.scheduleRoutineNotification(r);
        this.notifications[r.id!] = notificationId;
      }
      this.routines.clear();
    }
  }

  void removeRoutineNotification(Routine r) async {
    var notificationId = this.notifications[r.id!] ?? -1;
    if (notificationId != -1 && this.hasInit.value) {
      await this.flnp.cancel(notificationId);
    }
  }

  Future<int> scheduleRoutineNotification(Routine r) async {
    if (r.notificationsEnabled && this.hasInit.value) {
      // TODO: Maybe schedule this everyday? I don't know what happens with the app open more than 1 day
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
      await this.flnp.zonedSchedule(
            this.id++,
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
      return Future.value(this.id);
    }
    return Future.value(-1);
  }
}
