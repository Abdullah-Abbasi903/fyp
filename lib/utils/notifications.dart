import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:kidneyscan/controllers/notification_controller.dart';

class Notifications {
  static initializeTimeZone() {
  tz.initializeTimeZones();
  final String timeZoneName = tz.local.name;
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

static setNotifications() {
  AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod);

   twoHourNotification();
}

static Future<void> twoHourNotification() async {
  final String timeZone = tz.local.name;

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'basic_channel',
      title: 'Reminder',
      body: '2 hours complete, kindly drink water!',
      notificationLayout: NotificationLayout.Default,
    ),
    schedule: NotificationInterval(
      interval: 60,
      timeZone: timeZone,
      repeats: true,
    ),
  );
}
}


