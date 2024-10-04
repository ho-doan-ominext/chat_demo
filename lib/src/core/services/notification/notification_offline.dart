import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationOffline {
  NotificationOffline._();
  static final instance = NotificationOffline._();

  final _local = FlutterLocalNotificationsPlugin();

  Future<void> initial({
    DidReceiveLocalNotificationCallback? iosCallback,
    DidReceiveNotificationResponseCallback? receiveCallback,
    DidReceiveBackgroundNotificationResponseCallback? backgroundReceiveCallback,
  }) async {
    const initAndroidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final initIosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          iosCallback ?? _didReceiveLocalNotificationCallback,
    );
    final initialSettings = InitializationSettings(
      android: initAndroidSettings,
      iOS: initIosSettings,
    );
    await _local.initialize(
      initialSettings,
      onDidReceiveNotificationResponse: receiveCallback,
      onDidReceiveBackgroundNotificationResponse:
          backgroundReceiveCallback ?? _backgroundCallback,
    );
  }

  Future<void> requestIOSPermissions() async {
    await _local
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> sentNotification(
    int id, {
    required String title,
    required String body,
    required String? payload,
  }) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
      attachments: [],
    );
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
    await _local.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  void _didReceiveLocalNotificationCallback(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    log('_didReceiveLocalNotificationCallback payload: $payload');
  }
}

@pragma('vm:entry-point')
void _backgroundCallback(NotificationResponse response) {
  // ignore: avoid_print
  print('notification(${response.id}) action tapped: '
      '${response.actionId} with'
      ' payload: ${response.payload}');
  if (response.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print('notification action tapped with input: ${response.input}');
  }
}
