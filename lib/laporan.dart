import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class laporanpage extends StatefulWidget {
  const laporanpage({super.key});

  @override
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<laporanpage> {
  final _database = FirebaseDatabase.instance.ref(); // Inisialisasi Firebase Realtime Database
  List<Map<dynamic, dynamic>> _temperatureData = [];

  @override
  void initState() {
    super.initState();
    _loadTemperatureData();
  }

  // Mengambil data suhu dari Firebase
  Future<void> _loadTemperatureData() async {
  DataSnapshot snapshot = await _database.child('temperature_logs').get();
  if (snapshot.exists && snapshot.value is Map) {
    setState(() {
      // Mengonversi snapshot.value menjadi Map dan mengakses values-nya
      _temperatureData = List.from((snapshot.value as Map).values);
    });
  } else {
    print('No data found in Firebase');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Data Suhu Harian',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20,
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                        columns: const [
                          DataColumn(label: Text('Suhu', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          DataColumn(label: Text('Hari', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          DataColumn(label: Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          DataColumn(label: Text('Jam', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                        ],
                        rows: _temperatureData.map((data) {
                          return DataRow(cells: [
                            DataCell(Text('${data['temperature']}°C')),
                            DataCell(Text('${data['day']}')),
                            DataCell(Text('${data['date']}')),
                            DataCell(Text('${data['time']}')),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}