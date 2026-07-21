// Background service pentru alerte recurente
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Aici fetch UV + trimite notificare dacă expunere ridicată
    final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
    await notifications.show(
      0,
      'Alerta UV BeachMeter',
      'UV ridicat! Caută umbră sau reaplică cremă.',
      const NotificationDetails(android: AndroidNotificationDetails('uv_channel', 'UV Alerts')),
    );
    return true;
  });
}

class BackgroundService {
  static void initialize() {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    Workmanager().registerPeriodicTask('uv_alert', 'uv_alert_task',
        frequency: const Duration(minutes: 30));
  }
}