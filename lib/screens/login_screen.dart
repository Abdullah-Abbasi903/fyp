import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidneyscan/bars/navbar.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/controllers/internet_controller.dart';
import 'package:kidneyscan/database/firebase_db.dart';
import 'package:kidneyscan/keys/app_keys.dart';
import 'package:kidneyscan/screens/forgot_pass.dart';
import 'package:kidneyscan/screens/signup_screen.dart';
import 'package:kidneyscan/utils/switch_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isfound = false;
  bool? isChecked = false;
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  final passwordRegex = RegExp(
      r'^(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$');

  bool isObscure = true;
     
     rmemeberMe (bool value) async{
      SharedPreferences pref =  await SharedPreferences.getInstance();
      pref.setBool(AppKeys.loginKey, value);
     
     }
     @override
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        backgroundColor: AppColors().primaryColor,
        toolbarHeight: 12.h,
        title: Text(
          "Kidney Scan",
          style: GoogleFonts.pacifico(fontSize: 35, color: AppColors().white),
        ),
        centerTitle: true,
      ),
      body: Consumer<InternetController>(
        builder: (context, value, child) {
          return !value.isConnected
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_outlined,
                        size: 6.h,
                      ),
                      SizedBox(height: 2.h),
                      const Text("Please check your internet connection")
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 7.h),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors().secondaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              "Welcome Back",
                              style: GoogleFonts.prompt(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Image.asset(
                              "assets/images/login.png",
                              height: 120,
                              width: 120,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.h),
                              child: TextFormField(
                                controller: emailController,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !emailRegex.hasMatch(value)) {
                                    return 'please enter a valid email';
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  contentPadding: const EdgeInsets.all(15),
                                  hintText: "Enter Email",
                                  fillColor: AppColors().white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: AppColors().primaryColor,
                                        width: 4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: AppColors().primaryColor,
                                        width: 4),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.h),
                              child: TextFormField(
                                controller: passwordController,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !passwordRegex.hasMatch(value) ||
                                      value.length < 8) {
                                    return 'please enter a valid password \n'
                                        'Use  atleast one capital, one small, one number \n'
                                        'one special character';
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: isObscure,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  contentPadding: const EdgeInsets.all(15),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(
                                        () {
                                          isObscure = !isObscure;
                                        },
                                      );
                                    },
                                    child: Icon(
                                      isObscure == true
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                  hintText: "password",
                                  fillColor: AppColors().white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: AppColors().primaryColor,
                                        width: 4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: AppColors().primaryColor,
                                        width: 4),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {
                                      SwitchScreen()
                                          .push(context, const ForgotPass());
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          color: AppColors().black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.h),
                                Checkbox(
                                  value: isChecked,
                                  activeColor: AppColors().primaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked = value;
                                      rmemeberMe(isChecked!);
                                    });
                                  },
                                ),
                                Text(
                                  "Remember Me",
                                  style: TextStyle(
                                      color: AppColors().black,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            isfound
                                ? const CircularProgressIndicator()
                                : SizedBox(
                                    width: 20.h,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors().primaryColor,
                                        foregroundColor: AppColors().black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          setState(() {
                                            isfound = true;
                                          });
                                          // await FirebaseDb.getUser(
                                          //   context: context,
                                          //   userEmail: emailController.text,
                                          //   userPassword: passwordController.text,
                                          // );
                                          if (await FirebaseDb.getUser(
                                            context: context,
                                            userEmail: emailController.text,
                                            userPassword:
                                                passwordController.text,
                                          )) {
                                            SwitchScreen()
                                                .pushReplace(context, NavBar());
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      "Invalid Email or Password !",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                    content: const Text(
                                                        "Please try again"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text("OK"),
                                                      )
                                                    ],
                                                  );
                                                });
                                          }

                                          setState(() {
                                            isfound = false;
                                          });
                                        }
                                      },
                                      child: Text(
                                        "Sign in",
                                        style: GoogleFonts.rambla(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "dont have an account ?",
                                  style: GoogleFonts.rambla(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    SwitchScreen().push(
                                      context,
                                      const SignupScreen(),
                                    );
                                  },
                                  child: Text(
                                    'Sign up',
                                    style: GoogleFonts.rambla(
                                        fontSize: 20,
                                        color: const Color.fromARGB(
                                            255, 8, 137, 177),
                                        decoration: TextDecoration.underline),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
