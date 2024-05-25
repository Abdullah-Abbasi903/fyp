import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidneyscan/bars/navbar.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/keys/app_keys.dart';
import 'package:kidneyscan/screens/login_screen.dart';
import 'package:kidneyscan/utils/switch_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool gettingLogin = false;
  getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool(AppKeys.drawerKey);
  }

  

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(AppKeys.loginKey) ?? false;
    bool isThemeSet = prefs.getBool(AppKeys.drawerKey) ?? false;
    
    print("Login key is set to: $isLoggedIn");
    print("Theme key is set to: $isThemeSet");

    // Navigate after a short delay to show splash screen
    Timer(
      const Duration(seconds: 2),
      () {
        if (isLoggedIn) {
          SwitchScreen().pushReplace(
            context,
             NavBar(),
          );
        } else {
          SwitchScreen().pushReplace(
            context,
            const LoginScreen(),
          );
        }
      },
    );
  }

  @override
  void initState() {
  checkLoginStatus();
     
    getTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/svgs/splash.svg"),
            Text(
              'Kidney Scan',
              style: GoogleFonts.pacifico(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ),
    );
  }
}
