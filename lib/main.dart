import 'package:flutter/material.dart';
import 'package:flutter_application_3/main_page.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitoring Suhu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(), // Halaman utama
    );
  }
}


