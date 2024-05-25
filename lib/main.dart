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
