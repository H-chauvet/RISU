import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// LocalNotificationService class.
/// This class is used to show local notifications on the device.
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// init method.
  /// This method is used to initialize the local notification service.
  Future<void> init() async {
    // Initialize native android notification
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  /// showNotification method.
  /// This method is used to show notification on the device.
  /// params:
  /// [title] - String : Title of the notification.
  /// [value] - String : Value of the notification.
  void showNotificationAndroid(String title, String value) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'Channel Name',
            channelDescription: 'Channel Description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    int notificationId = 1;
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        notificationId, title, value, notificationDetails,
        payload: 'Not present');
  }
}
