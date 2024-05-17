import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidneyscan/bars/navbar.dart';
import 'package:kidneyscan/bars/top_bar.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/utils/switch_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class InputData extends StatefulWidget {
  const InputData({super.key});

  @override
  State<InputData> createState() => _InputDataState();
}

class _InputDataState extends State<InputData> {
  TextEditingController waterController = TextEditingController();
  TextEditingController bloodController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 15.8.h,
            child: const TopBar(),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                // Adjust opacity here
                image: DecorationImage(
                  image: const AssetImage(
                    "assets/images/back.PNG",
                  ),
                  fit: BoxFit.fitWidth,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(
                        0.3), // Additional overlay color with opacity
                    BlendMode.dstATop, // Blend mode to mix the colors
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.h),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      //  mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          "Please fill the following to proceed further",
                          style: GoogleFonts.rambla(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors().primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 17.h,
                        ),
                        TextFormField(
                          controller: waterController,
                          validator: (value) {
                            if (value!.isEmpty || value == 0) {
                              return "Please enter correct info";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter your water intake (mL)",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors().primaryColor, width: 4),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        TextFormField(
                          controller: bloodController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter correct info";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter your blood pressure (mmHg)",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors().primaryColor, width: 4),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors().primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              SwitchScreen().pushReplace(
                                  context,
                                  NavBar(
                                    water: waterController.text,
                                    blood: bloodController.text,
                                  ));
                            }
                          },
                          child: Text(
                            "Confirm",
                            style: TextStyle(color: AppColors().black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
