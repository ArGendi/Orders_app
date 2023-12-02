import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationServices{
  static FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  static void onNotificationTap(NotificationResponse notificationResponse){
    onClickNotification.add(notificationResponse.payload!);
  }

  static Future<void> init() async{
    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings iOSInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id,title,body,payload){
        onClickNotification.add(payload!);
      }
    );
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  static NotificationDetails getNotificationDetails(){
    return NotificationDetails(
      android: AndroidNotificationDetails("channelId", "channelName", importance: Importance.max, priority: Priority.high),
      iOS: DarwinNotificationDetails(),
    );
  }

  static void showNotification(int id, String title, String body){
    notificationsPlugin.show(id, title, body, getNotificationDetails());
  }

  static void showPeriodNotification(int id, String title, String body){
    notificationsPlugin.periodicallyShow(id, title, body, RepeatInterval.everyMinute, getNotificationDetails());
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async{
    //var now = tz.TZDateTime.now(tz.local);
    await notificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime(tz.local, time.year, time.month, time.day, 16,13), 
    const NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description')),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
    print("done");
    print("${tz.TZDateTime.now(tz.local).location.name}");
  }

  static void cancel(int id){
    notificationsPlugin.cancel(id);
  }

  static void cancelAll(int id){
    notificationsPlugin.cancelAll();
  }


}


void test(){
  DateTime now = DateTime.now();
  now.day + 1;
  now.add(Duration(hours: 2));
}

// tz.TZDateTime(tz.local, now.year, now.month + 1, now.day, now.hour);
// tz.TZDateTime(tz.local, 2023, 11, 4, 10); 3/11/2023
// tz.TZDateTime(tz.local, now.year, 10, 6, 10);