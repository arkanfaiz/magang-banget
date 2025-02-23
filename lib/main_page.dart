import 'package:flutter/material.dart';
import 'package:flutter_application_3/cctv.dart';
import 'package:flutter_application_3/laporan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_application_3/monitoring.dart';
import 'package:flutter_application_3/suhu.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Meminta izin untuk notifikasi
    _requestNotificationPermission();

    // Inisialisasi notifikasi
    _initializeNotifications();
  }

  // Meminta izin untuk menampilkan notifikasi
  Future<void> _requestNotificationPermission() async {
    // Cek izin untuk notifikasi
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      print("Izin notifikasi diberikan");
    } else {
      print("Izin notifikasi ditolak");
    }
  }

  // Fungsi untuk inisialisasi notifikasi
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Fungsi untuk menampilkan notifikasi
  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'Network Connectivity',
      channelDescription: 'Notifikasi koneksi jaringan',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // ID notifikasi
      'No Network Connection',
      'Your device is not connected to the internet.',
      platformDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MANTAP LEE",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 122, 185),
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 121, 202, 255),
              const Color.fromARGB(255, 254, 254, 254)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _showNotification, // Memanggil fungsi untuk menampilkan notifikasi
                child: const Text('Test Notification'),
              ),
              buildMenuButton(
                context,
                icon: Icons.thermostat,
                label: "Suhu",
                page: suhupage(),
              ),
              buildMenuButton(
                context,
                icon: Icons.monitor_heart,
                label: "Monitoring",
                page: MonitoringPage(),
              ),
              buildMenuButton(
                context,
                icon: Icons.videocam,
                label: "CCTV",
                page: Cctv(),
              ),
              buildMenuButton(
                context,
                icon: Icons.article,
                label: "Laporan",
                page: laporanpage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuButton(BuildContext context,
      {required IconData icon, required String label, required Widget page}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        width: 300,
        height: 60,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          },
          icon: Icon(icon, size: 28),
          label: Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(255, 0, 21, 255),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Color.fromARGB(255, 0, 21, 255)),
            ),
            elevation: 5,
          ),
        ),
      ),
    );
  }
}
