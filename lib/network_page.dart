import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  late final WebViewController _controller;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initNotifications(); // Inisialisasi notifikasi
    checkServerStatus(); // Mulai cek status server

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('http://your-nagvis-server/nagvis/'));
  }

  /// Fungsi untuk inisialisasi notifikasi
  void initNotifications() {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);
    flutterLocalNotificationsPlugin.initialize(settings);
  }

  /// Fungsi untuk mengecek status jaringan NagVis
  void checkServerStatus() {
    final ping = Ping('your-nagvis-server');
    ping.stream.listen((event) {
      if (event.response == null) {
        print("Server tidak bisa diakses!");
        showNotification("Jaringan NagVis bermasalah!");
      }
    });
  }

  /// Fungsi untuk menampilkan notifikasi
  void showNotification(String message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NagVis Network View")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
