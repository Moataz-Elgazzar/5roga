import 'package:app_5roga/core/services/notification/local_notification.dart';
import 'package:workmanager/workmanager.dart';

class WorkManager {
  static Workmanager workManager = Workmanager();
  static void registerMyTask() {
    final String id = 'DateTime.now().millisecondsSinceEpoch ~/ 4000';
    workManager.registerPeriodicTask(id, 'show notification', frequency: const Duration(minutes: 15));
  }

  static Future<void> init() async {
    await workManager.initialize(callbackDispatcher, isInDebugMode: true);
    registerMyTask();
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    LocalNotificationService.weeklySchduledNotification();
    return Future.value(true);
  });
}
