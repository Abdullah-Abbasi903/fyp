import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/controllers/internet_controller.dart';
import 'package:kidneyscan/controllers/theme_controller.dart';
import 'package:kidneyscan/database/firebase_db.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AppColors().white,
          appBar: AppBar(
            elevation: 5.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            backgroundColor: viewModel.primaryColor(context),
            toolbarHeight: 12.h,
            title: Text(
              "Kidney Scan",
              style: GoogleFonts.pacifico(
                fontSize: 35,
                color: viewModel.currentTheme== ThemeData.dark()? AppColors().white:AppColors().white,
              ),
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
                        decoration: BoxDecoration(
                          color: viewModel.primaryColor(context),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              TextFormField(
                                controller: _emailController,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !emailRegex.hasMatch(value)) {
                                    return "Please Provide Correct Email!";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  hintText: 'Enter Recovery Email',
                                  contentPadding: const EdgeInsets.all(15),
                                  fillColor:viewModel.currentTheme== ThemeData.dark()? AppColors().darkGrey:AppColors().white,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: AppColors().primaryColor,
                                        width: 4),
                                  ),
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
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              isLoading
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: viewModel.currentTheme==ThemeData.dark()?AppColors().darkGrey:AppColors().primaryColor,
                                           
                                        foregroundColor: AppColors().black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          FirebaseDb.recover(
                                            userEmail: _emailController.text,
                                          );
                                          Future.delayed(
                                              const Duration(seconds: 4), () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return const AlertDialog(
                                                  title: Text(
                                                      "Email Sent To Recover Password"),
                                                  content: Text(
                                                      "Please Make sure to follow the password scheme"),
                                                );
                                              },
                                            );
                                            setState(() {
                                              isLoading = false;
                                            });
                                          });
                                        }
                                      },
                                      child: const Text("       Reset        "),
                                    )
                            ],
                          ),
                        ),
                      ),
                    );
            },
          ),
        );
      },
    );
  }
}
