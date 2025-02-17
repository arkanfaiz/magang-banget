import 'package:flutter/material.dart';
//import 'package:flutter_application_3/cctv.dart';
import 'package:flutter_application_3/monitoring.dart';
import 'package:flutter_application_3/suhu.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

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
              //                buildMenuButton(
              //   context,
              //   icon: Icons.videocam,
              //   label: "Cctv",
              //   page: cctv(),
              // ),
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
