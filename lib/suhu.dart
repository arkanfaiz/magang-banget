import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class suhupage extends StatefulWidget {
  const suhupage({super.key});

  @override
  _SuhuPageState createState() => _SuhuPageState();
}

class _SuhuPageState extends State<suhupage> {
  double _temperature = 0.0;
  String _humidity = '';
  String _day = '';
  String _date = '';
  String _time = '';
  Timer? _temperatureTimer;
  Timer? _dateTimeTimer;
  Timer? _historyTimer;

  final _database = FirebaseDatabase.instance.ref();

  // List untuk menyimpan data historis setiap 30 menit
  List<Map<String, dynamic>> _temperatureHistory = [];

  @override
void initState() {
  super.initState();
  _updateTemperature();
  _updateDateTime();

  _temperatureTimer = Timer.periodic(Duration(seconds: 5), (Timer t) {
    _updateTemperature();
  });

  _dateTimeTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
    _updateDateTime();
  });

  _historyTimer = Timer.periodic(Duration(minutes: 1), (Timer t) {
    _addToHistory();
  });

  startFirebaseSync(); // Ganti Timer.periodic dengan loop async
}



  @override
  void dispose() {
    _temperatureTimer?.cancel();
    _dateTimeTimer?.cancel();
    _historyTimer?.cancel();
    super.dispose();
  }

  void startFirebaseSync() async {
  while (true) {
    await _saveTemperatureToFirebase();
    await Future.delayed(Duration(minutes: 1)); // Tunggu 1 menit sebelum loop lagi
  }
}


  // Method untuk menambahkan data ke list historis
  void _addToHistory() {
    setState(() {
      _temperatureHistory.add({
        'temperature': _temperature,
        'humidity': _humidity,
        'time': _time,
        'date': _date,
      });
    });
    print("Data historis ditambahkan: $_temperatureHistory");
  }

  void _updateTemperature() async {
    final url = 'http://172.17.81.224/sensor_suhu/api/suhu_update.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _temperature = double.parse(data['data'][0]['suhu']);
          _humidity = data['data'][0]['kelembaban'];
        });
        print("Suhu: $_temperature, Kelembaban: $_humidity"); // Log nilai suhu dan kelembaban
      } else {
        print('Gagal memuat data suhu dan kelembaban');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _saveTemperatureToFirebase() async {
  try {
    final newDataRef = _database.child('temperature_logs').push();
    await newDataRef.update({  // Ganti dari set() ke update()
      'temperature': _temperature,
      'humidity': _humidity,
      'day': _day,
      'date': _date,
      'time': _time,
      'timestamp': ServerValue.timestamp, // Timestamp dari Firebase langsung
    });
    print("✅ Data suhu berhasil diperbarui di Firebase");
  } catch (e) {
    print("❌ Gagal memperbarui data suhu di Firebase: $e");
  }
}


  void _updateDateTime() {
    final now = DateTime.now();
    List<String> days = [
      'Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'
    ];
    setState(() {
      _day = days[now.weekday % 7];
      _date = "${now.day}-${now.month}-${now.year}";
      _time = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Monitoring Suhu Server AOCC',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.blue.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding di sekitar seluruh body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian atas: Data real-time
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '$_temperature°C',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _day,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _date,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _time,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Kelembaban: $_humidity%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Bagian bawah: Data historis dengan GridView
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 items per row
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _temperatureHistory.length > 10 ? 10 : _temperatureHistory.length,
                      itemBuilder: (context, index) {
                        final data = _temperatureHistory[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text("Suhu: ${data['temperature']}°C", style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("Kelembaban: ${data['humidity']}% - ${data['date']} ${data['time']}"),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_temperatureHistory.length > 10)
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return ListView.builder(
                              itemCount: _temperatureHistory.length,
                              itemBuilder: (context, index) {
                                final data = _temperatureHistory[index];
                                return ListTile(
                                  title: Text("Suhu: ${data['temperature']}°C"),
                                  subtitle: Text("Kelembaban: ${data['humidity']}% - ${data['date']} ${data['time']}"),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Text("Lihat Semua Data"),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
