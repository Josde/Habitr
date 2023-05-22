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
  Map<int, List<int>> notifications = Map();
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
        var notificationIds = await this.scheduleRoutineNotification(r);
        this.notifications[r.id!] = notificationIds;
      }
      this.routines.clear();
    }
  }

  void removeRoutineNotification(Routine r) async {
    var notificationIds = this.notifications[r.id!];
    if (this.hasInit.value) {
      for (var id in notificationIds ?? List.empty()) {
        await this.flnp.cancel(id);
      }
    }
  }

  Future<List<int>> scheduleRoutineNotification(Routine r) async {
    List<int> returnIds = List.empty(growable: true);
    if (r.notificationsEnabled && this.hasInit.value) {
      // TODO: Maybe schedule this everyday? I don't know what happens with the app open more than 1 day
      DateTime _nowTemp = DateTime.now();
      tz.TZDateTime now = tz.TZDateTime.local(
        _nowTemp.year,
        _nowTemp.month,
        _nowTemp.day,
        _nowTemp.hour,
        _nowTemp.minute,
      );
      int startingDay = now.weekday;
      for (int dayOfWeek = now.weekday; dayOfWeek <= 7; dayOfWeek++) {
        if (r.notificationDaysOfWeek[dayOfWeek - 1]) {
          tz.TZDateTime finalDateTime = tz.TZDateTime.local(
              now.year,
              now.month,
              now.day + (dayOfWeek - startingDay),
              r.notificationStartTime.hour,
              r.notificationStartTime.minute,
              0);
          if (now.isAfter(finalDateTime)) {
            continue; // Skip adding routines if today already passed
          }
          await this.flnp.zonedSchedule(
                ++this.id,
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
          returnIds.add(this.id);
          print(
              "Scheduling ${r.name} for ${finalDateTime.hour}:${finalDateTime.minute} on ${finalDateTime.day}");
        }
      }
    }
    return Future.value(returnIds);
  }
}
