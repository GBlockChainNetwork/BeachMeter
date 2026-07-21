// Template Flutter basic pentru BeachMeter
import 'package:flutter/material.dart';

void main() {
  runApp(const BeachMeterApp());
}

class BeachMeterApp extends StatelessWidget {
  const BeachMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeachMeter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BeachMeter')),
      body: const Center(child: Text('UV Dashboard - Coming soon!')),
    );
  }
}