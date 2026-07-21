import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int skinType = 3; // Fitzpatrick default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Tip de piele (Fitzpatrick)'),
            Slider(
              value: skinType.toDouble(),
              min: 1,
              max: 6,
              divisions: 5,
              onChanged: (val) => setState(() => skinType = val.toInt()),
            ),
            Text('Tip $skinType - ${getSkinDescription(skinType)}'),
          ],
        ),
      ),
    );
  }

  String getSkinDescription(int type) {
    switch (type) {
      case 1: return 'Foarte clar - arde ușor';
      case 6: return 'Închis - rareori arde';
      default: return 'Mediu';
    }
  }
}