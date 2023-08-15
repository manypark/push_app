import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_app/config/router/app_router.dart';

class LocalNotiofications {

  static Future<void> requestPermissionLocalNotifications() async {

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  }

  static Future<void> initializeLocalNotifications() async {

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    //TODO ios config

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      //TODO ios config
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
    );

  }

  static void showLocalNotifications({
    required int id,
    String? title,
    String? body,
    String? data
  }) {

    const androidDetails = AndroidNotificationDetails(
      'channelId', 
      'channelName',
      playSound : true,
      sound     : RawResourceAndroidNotificationSound('notifications_sound'),
      importance: Importance.high,
      priority  : Priority.max
    );

    const notificationsDetail = NotificationDetails(
      android: androidDetails,
      //TODO ios config
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.show(id, title, body, notificationsDetail, payload: data);
  }

  static void onDidReceiveNotificationResponse( NotificationResponse response ) {
    appRouter.push('/push-details/${response.payload}');
  }

}
