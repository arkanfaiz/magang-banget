import 'package:flutter/material.dart';
import 'dart:async';

class suhupage extends StatefulWidget {
  const suhupage({super.key});

  @override
  _suhupageState createState() => _suhupageState();
}

class _suhupageState extends State<suhupage> {
  double? deviceTemperature;
  bool isLoading = true;
  String errorMessage = '';
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchDeviceTemperature();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchDeviceTemperature();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchDeviceTemperature() async {
    try {
      double? batteryTemp = await getBatteryTemperature();
      setState(() {
        deviceTemperature = batteryTemp;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  Future<double?> getBatteryTemperature() async {
    return null;
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Suhu Perangkat (Real-Time)')),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : deviceTemperature != null
                ? Text(
                    'Suhu perangkat: ${deviceTemperature!.toStringAsFixed(1)}°C',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                : Text(
                    errorMessage.isNotEmpty
                        ? errorMessage
                        : 'Gagal mengambil data suhu',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
      ),
    );
  }
}

