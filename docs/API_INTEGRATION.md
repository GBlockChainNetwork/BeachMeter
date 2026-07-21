# API Integration Guide

## Surse principale
- **Open-Meteo**: UV Index + meteo (gratuit, hourly)
- **OpenUV**: Detalii avansate + skin type
- **NOAA/NASA**: Fallback

## Exemplu cod (Dart/Flutter)
```dart
Future<double> getUVIndex(double lat, double lon) async {
  final response = await http.get(Uri.parse('https://api.open-meteo.com/...'));
  // parse JSON
}
```

Rate limits: respectă-le. Cache cu Hive.