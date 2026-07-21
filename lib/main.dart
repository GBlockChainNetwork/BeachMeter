// Template Flutter basic extins pentru BeachMeter
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const BeachMeterApp());
}

class BeachMeterApp extends StatelessWidget {
  const BeachMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeachMeter',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? uvIndex;
  String status = 'Loading...';

  @override
  void initState() {
    super.initState();
    _getLocationAndUV();
  }

  Future<void> _getLocationAndUV() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => status = 'Activează GPS-ul');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => status = 'Permisiune GPS refuzată');
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    final uv = await fetchUVIndex(position.latitude, position.longitude);
    setState(() {
      uvIndex = uv;
      status = 'UV Index: ${uv?.toStringAsFixed(1) ?? "-"}';
    });
  }

  Future<double?> fetchUVIndex(double lat, double lon) async {
    try {
      final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=uv_index'
      ));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['hourly']['uv_index'][0].toDouble(); // current hour
      }
    } catch (e) {
      print('API error: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BeachMeter - Protejează-te!')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(status, style: const TextStyle(fontSize: 24)),
            if (uvIndex != null)
              Text('Risc: ${getUVRisk(uvIndex!)}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocationAndUV,
              child: const Text('Refresh UV'),
            ),
          ],
        ),
      ),
    );
  }

  String getUVRisk(double uv) {
    if (uv >= 11) return 'Extrem - Caută umbră!';
    if (uv >= 8) return 'Foarte ridicat';
    if (uv >= 6) return 'Ridicat';
    return 'Moderată / Scăzută';
  }
}