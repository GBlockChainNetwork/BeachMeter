import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerte Recurente')),
      body: const Center(
        child: Text('Lista alerte UV + istoricul expunerii\n\n(Implementare background service aici)'),
      ),
    );
  }
}