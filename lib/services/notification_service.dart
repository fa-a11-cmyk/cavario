import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Demander permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Configuration notifications locales
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings);

    // Écouter les messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    await _showLocalNotification(
      title: message.notification?.title ?? 'Cavario',
      body: message.notification?.body ?? 'Nouvelle notification',
    );
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    debugPrint('Background message: ${message.messageId}');
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'cavario_channel',
      'Cavario Notifications',
      channelDescription: 'Notifications pour les événements équestres',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  static Future<void> scheduleEventNotification({
    required String eventTitle,
    required DateTime eventDate,
  }) async {
    final scheduledDate = eventDate.subtract(const Duration(hours: 1));
    
    await _localNotifications.zonedSchedule(
      eventDate.hashCode,
      'Événement à venir',
      '$eventTitle commence dans 1 heure',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'event_reminders',
          'Rappels d\'événements',
          channelDescription: 'Rappels pour les événements équestres',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}