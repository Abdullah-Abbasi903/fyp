import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/database/firebase_db.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
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
      body: Padding(
        padding: EdgeInsets.only(top: 7.h),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors().secondaryColor,
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
                    if (value!.isEmpty || !emailRegex.hasMatch(value)) {
                      return "Please Provide Correct Email!";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: 'Enter Recovery Email',
                    contentPadding: const EdgeInsets.all(15),
                    fillColor: AppColors().white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: AppColors().primaryColor, width: 4),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: AppColors().primaryColor, width: 4),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: 20.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColor,
                      foregroundColor: AppColors().black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                            
                            FirebaseDb.recover(userEmail: _emailController.text);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text("Email Sent To Recover Password"),
                              content: Text("please Make sure to follw the password scheme"),
                            );
                          },
                        );
                      }
                    },
                    child: const Text("Reset"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
