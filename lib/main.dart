import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:kidneyscan/controllers/db_controller.dart';
import 'package:kidneyscan/controllers/home_controller.dart';
import 'package:kidneyscan/controllers/internet_controller.dart';
import 'package:kidneyscan/controllers/notification_controller.dart';
import 'package:kidneyscan/controllers/theme_controller.dart';
import 'package:kidneyscan/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyAMseHRwzOtMvniXeVDoIz3T61CUbolOJc',
          appId: "1:403688708332:android:414cda6e46c0ddb9f42dc9",
          projectId: "erudite-acre-359605", messagingSenderId: ''));
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
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
        importance: NotificationImportance.High,
        // Ensure high importance
        channelShowBadge: true,
        // Show badge on icon
        playSound: true,
        // Play sound for notifications
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
              home: SplashScreen(),
            );
          });
        },
      ),
    );
  }
}
