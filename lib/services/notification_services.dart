import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:tasks/ui/pages/notified_page.dart';
import 'package:tasks/models/task.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); //

  initializeNotification() async {
    _congfigLocalTimeZone();
    // this is for latest iOS settings
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings("appicon");

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Get.defaultDialog(
        title: payload.toString().split("|")[0],
        middleText: payload.toString().split("|")[1],
        radius: 30); //Get.to(() => NotifiedPage(
    // label: payload!,
    // ));
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}

  displayNotification({required String title, required String body}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high);

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: "payload",
    );
  }

  scheduledNotification(int hour, int min, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt(),
        task.title,
        task.note,
        _converTime(hour, min),
        payload: '${task.title} | ${task.note}',
        //tz.TZDateTime.now(tz.local).add(Duration(seconds: min)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        //  androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _converTime(int hr, int min) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime shdate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hr, min);
    if (shdate.isBefore(now)) {
      shdate = shdate.add(const Duration(minutes: 10));
    }
    return shdate;
  }

  Future<void> _congfigLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }
}
