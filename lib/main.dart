// Main app cu navigare completă, timer expunere și local storage
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/alerts_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/map_screen.dart';

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
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  double? uvIndex;
  DateTime? exposureStart;
  int skinType = 3;
  final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();

  final List<Widget> _screens = [
    const HomeUVScreen(),
    const MapScreen(),
    const AlertsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _getCurrentUV();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      skinType = prefs.getInt('skinType') ?? 3;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('skinType', skinType);
  }

  Future<void> _getCurrentUV() async {
    // GPS + API logic (similar previous)
    try {
      Position position = await Geolocator.getCurrentPosition();
      final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&hourly=uv_index'
      ));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() => uvIndex = data['hourly']['uv_index'][0].toDouble());
      }
    } catch (e) {
      print(e);
    }
  }

  void _startExposureTimer() {
    setState(() => exposureStart = DateTime.now());
    // Timer logic + notifications
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Timer expunere pornit!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BeachMeter')),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.sunny), label: 'UV'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Hartă'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alerte'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startExposureTimer,
        child: const Icon(Icons.timer),
      ),
    );
  }
}

// Placeholder pentru HomeUVScreen (poți muta logica din vechiul main)
class HomeUVScreen extends StatelessWidget {
  const HomeUVScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Dashboard UV Principal\n\nApasă timer pentru expunere'));
  }
}