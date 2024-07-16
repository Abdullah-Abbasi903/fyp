import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidneyscan/bars/navbar.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/controllers/internet_controller.dart';
import 'package:kidneyscan/database/firebase_db.dart';
import 'package:kidneyscan/screens/login_screen.dart';
import 'package:kidneyscan/utils/snack.dart';
import 'package:kidneyscan/utils/switch_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  final emaiRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  final passwordRegex = RegExp(
      r'^(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$');

  final noRegex = RegExp(r'^03[0-9]{9}$');

  bool isObscure = true;
  bool isConfirmObscure = true;
  bool isCreating = false;
  bool isGoolgeCreating = false;

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    numberController.clear();
    passwordController.clear();
    cPasswordController.clear();
  }

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
                              "Register Account",
                              style: GoogleFonts.prompt(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.h),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'this field cannot be empty';
                                  } else {
                                    return null;
                                  }
                                },
                                controller: nameController,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      const Icon(Icons.account_circle_outlined),
                                  contentPadding: const EdgeInsets.all(15),
                                  hintText: "Enter Full Name",
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
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      value.length < 11 ||
                                      value.contains(".") ||
                                      !noRegex.hasMatch(value)) {
                                    return 'Please enter a valid number';
                                  } else {
                                    return null;
                                  }
                                },
                                controller: numberController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.call),
                                  contentPadding: const EdgeInsets.all(15),
                                  hintText: "Enter Number",
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
                                validator: (value) {
                                  if (value!.isEmpty &&
                                      !emaiRegex.hasMatch(value)) {
                                    return 'please enter a valid email';
                                  } else {
                                    return null;
                                  }
                                },
                                controller: emailController,
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
                                controller: passwordController,
                                obscureText: isObscure,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
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
                              height: 2.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.h),
                              child: TextFormField(
                                controller: cPasswordController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'this field cannot be empty';
                                  } else if (value != passwordController.text) {
                                    return "password dose not match";
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: isConfirmObscure,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(
                                        () {
                                          isConfirmObscure = !isConfirmObscure;
                                        },
                                      );
                                    },
                                    child: Icon(
                                      isConfirmObscure == true
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                  hintText: "confirm password",
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
                                  contentPadding: const EdgeInsets.all(15),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            isCreating
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
                                            isCreating = true;
                                          });

                                          if (await FirebaseDb.createUser(
                                            userEmail:
                                                emailController.text.trim(),
                                            userName:
                                                nameController.text.trim(),
                                            userNumber:
                                                numberController.text.trim(),
                                            userPassword:
                                                passwordController.text,
                                          )) {
                                            snackBar(
                                                context,
                                                "User Registered Successfully",
                                                AppColors().primaryColor);
                                            Future.delayed(
                                                const Duration(seconds: 2), () {
                                              SwitchScreen().pushReplace(
                                                context,
                                                const LoginScreen(),
                                              );
                                            });
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return const AlertDialog(
                                                  title: Text(
                                                    "Attention!",
                                                  ),
                                                  content: Text(
                                                    "Email Already Registered!",
                                                  ),
                                                );
                                              },
                                            );
                                          }

                                          setState(() {
                                            isCreating = false;
                                          });

                                          clearControllers();
                                        }
                                      },
                                      child: Text(
                                        "Sign up",
                                        style: GoogleFonts.rambla(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5.h),
                                    child: const Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    "or",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 5.h),
                                    child: const Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            isGoolgeCreating
                                ? const CircularProgressIndicator()
                                : SignInButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    Buttons.google,
                                    onPressed: () async {
                                      setState(() {
                                        isGoolgeCreating = true;
                                      });
                                    FirebaseDb.signInWithGoogle(context);


                                      setState(() {
                                        isGoolgeCreating = false;
                                      });
                                    },
                                  ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "already have an account ?",
                                  style: GoogleFonts.rambla(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    SwitchScreen().push(
                                      context,
                                      const LoginScreen(),
                                    );
                                  },
                                  child: Text(
                                    'Sign in',
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
