import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

initializeNotification() async {
  var initiallizeAndroid = AndroidInitializationSettings('ic_launcher');
  var initiallizeIOS = IOSInitializationSettings();
  var initSettings = InitializationSettings(initiallizeAndroid, initiallizeIOS);
  await localNotificationsPlugin.initialize(initSettings);
}

Future<void> notifications(BuildContext context, TimeOfDay _time,
    String message, bool isSchedule, int interval, int min) async {
  // print(min);
  // print(_time);
  // print(interval);
  // print(int.parse((_time.hour.toString() + _time.minute.toString())));
  var time = Time(_time.hour, _time.minute, 0);

  DateTime now = DateTime.now().toUtc().add(Duration(seconds: min));

  await singleNotification(
      localNotificationsPlugin,
      now,
      " It's time to take your medicine",
      message,
      int.parse((_time.hour.toString() + _time.minute.toString())),
      _time.format(context),
      time,
      isSchedule,
      _time,
      interval);
}

Future singleNotification(
  FlutterLocalNotificationsPlugin plugin,
  DateTime date,
  String message,
  String subText,
  int hashcode,
  String channelId,
  Time time,
  bool isSchedule,
  TimeOfDay _time,
  int interval,
) async {
  var androidChannel = AndroidNotificationDetails(
    channelId,
    'chanel-name',
    'chanel-description',
    // sound: 'sound',
    importance: Importance.Max,
    priority: Priority.Max,
  );
  // print(hashcode);
  // print(isSchedule);
  // print(interval);
  int hour = _time.hour;
  var ogValue = hour;
  var iosChannel = IOSNotificationDetails();
  var platformChannel = NotificationDetails(androidChannel, iosChannel);
  if (isSchedule) {
    // print('Schedule');

    await plugin.schedule(
      hashcode,
      message,
      subText,
      date,
      platformChannel,
    );
  } else {
    // print('Interval:$interval');
    for (int i = 0; i < (24 / interval).floor(); i++) {
      if ((hour + (interval * i) > 23)) {
        hour = hour + (interval * i) - 24;
      } else {
        hour = hour + (interval * i);
      }
      await plugin.showDailyAtTime(
          hashcode, message, subText, time, platformChannel);
      hour = ogValue;
    }
  }
}
