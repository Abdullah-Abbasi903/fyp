import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:kidneyscan/controllers/db_controller.dart';
import 'package:kidneyscan/controllers/home_controller.dart';
import 'package:kidneyscan/controllers/internet_controller.dart';
import 'package:kidneyscan/controllers/notification_controller.dart';
import 'package:kidneyscan/controllers/theme_controller.dart';
import 'package:kidneyscan/screens/report_screen.dart';
import 'package:kidneyscan/screens/single_view.dart';
import 'package:kidneyscan/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'bars/navbar.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeTimeZone();
  
   AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High, // Ensure high importance
        channelShowBadge: true, // Show badge on icon
        playSound: true, // Play sound for notifications
        enableVibration: true, // Enable vibration
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      )
    ],
    debug: true,
  );

  bool isAllowedToSend = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSend) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
    onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
    onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
  );

   twoHourNotification();

  runApp(const MyApp());
}

Future<void> twoHourNotification() async {
  final String timeZone = tz.local.name;

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'basic_channel',
      title: 'Time to Hydrate!',
      body: 'It has been 2 hours. Please drink some water to stay hydrated!',
      notificationLayout: NotificationLayout.Default,
    ),
    schedule: NotificationInterval(
      interval: 60, 
      timeZone: timeZone,
      repeats: true,
    ),
  );
}

void initializeTimeZone() {
  tz.initializeTimeZones();
  final String timeZoneName = tz.local.name;
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => InternetController()),
        ChangeNotifierProvider(create: (_) => DbController()),
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return Consumer<ThemeController>(builder: (context, value, child) {
            return MaterialApp(
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
              ),
              theme: value.currentTheme,
              home:  NavBar(),
            );
          });
        },
      ),
    );
  }
}
