import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initNotifications() {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings settings =
      InitializationSettings(android: androidSettings);
  flutterLocalNotificationsPlugin.initialize(settings);
}

void checkServerStatus() {
  final ping = Ping('your-nagvis-server');

  ping.stream.listen((event) {
    if (event.response == null) {
      print("Server tidak bisa diakses!");
      // Kirim notifikasi jika gagal
      showNotification("Jaringan NagVis bermasalah!");
    }
  });
}

void showNotification(String message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'channel_id',
    'Network Alerts',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails details =
      NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(
      0, 'Peringatan Jaringan', message, details);
}
