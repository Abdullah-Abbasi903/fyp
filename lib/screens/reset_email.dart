import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidneyscan/controllers/db_controller.dart';
import 'package:kidneyscan/controllers/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/colors/app_colors.dart';

class ResetEmailScreen extends StatefulWidget {
  const ResetEmailScreen({super.key});

  @override
  State<ResetEmailScreen> createState() => _ResetEmailScreenState();
}

class _ResetEmailScreenState extends State<ResetEmailScreen> {
  final TextEditingController currentEmail = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController newEmail = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<DbController>(
      builder: (context, value, child) {
        return Consumer<ThemeController>(
          builder: (context, viewModel, child) {
            return Scaffold(
              backgroundColor: AppColors().white,
              resizeToAvoidBottomInset: false,
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
                      fontSize: 35, color: AppColors().white),
                ),
                centerTitle: true,
              ),
              body: Consumer<DbController>(
                builder: (context, value, child) {
                  return Padding(
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
                              controller: currentEmail,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !emailRegex.hasMatch(value)) {
                                  return "Enter Your Current Email!";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined),
                                hintText: 'Enter Current Email',
                                contentPadding: const EdgeInsets.all(15),
                                fillColor: viewModel.currentTheme== ThemeData.dark()? AppColors().darkGrey:AppColors().white,
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
                              height: 2.h,
                            ),
                            TextFormField(
                              controller: password,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter Old Password!";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined),
                                hintText: 'Enter Current Password',
                                contentPadding: const EdgeInsets.all(15),
                                fillColor: viewModel.currentTheme== ThemeData.dark()? AppColors().darkGrey:AppColors().white,
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
                              height: 2.h,
                            ),
                            TextFormField(
                              controller: newEmail,
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
                                hintText: 'Enter New Email',
                                contentPadding: const EdgeInsets.all(15),
                                fillColor: viewModel.currentTheme== ThemeData.dark()? AppColors().darkGrey:AppColors().white,
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        value
                                            .changeEmail(currentEmail.text,
                                                password.text, newEmail.text)
                                            .then((value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text("Email has been sent"),
                                            duration: Duration(seconds: 3),
                                          ));
                                          Navigator.pop(context);
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
      },
    );
  }
}
