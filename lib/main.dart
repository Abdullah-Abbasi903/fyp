import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:kidneyscan/controllers/db_controller.dart';
import 'package:kidneyscan/controllers/home_controller.dart';
import 'package:kidneyscan/controllers/internet_controller.dart';
import 'package:kidneyscan/controllers/theme_controller.dart';
import 'package:kidneyscan/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  bool isAllowedToSend = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSend) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(const MyApp());
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
              home: const SplashScreen(),
            );
            // child:
          });
        },
      ),
    );
  }
}
