import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/database/firebase_db.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class InputData extends StatefulWidget {
  const InputData({super.key});

  @override
  State<InputData> createState() => _InputDataState();
}

class _InputDataState extends State<InputData> {
  final _formKey = GlobalKey<FormState>();
  final _waterController = TextEditingController();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();

  @override
  void dispose() {
    _waterController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    super.dispose();
  }

  String? _validateWaterIntake(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter water intake level';
    }
    final intake = int.tryParse(value);
    if (intake == null || intake <= 0) {
      return 'Please enter a valid water intake level';
    }
    return null;
  }

  String? _validateSystolic(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter systolic pressure';
    }
    final systolic = int.tryParse(value);
    if (systolic == null || systolic < 90 || systolic > 180) {
      return 'Please enter a valid systolic pressure (90-180)';
    }
    return null;
  }

  String? _validateDiastolic(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter diastolic pressure';
    }
    final diastolic = int.tryParse(value);
    if (diastolic == null || diastolic < 60 || diastolic > 120) {
      return 'Please enter a valid diastolic pressure (60-120)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                          "Please fill the following details",
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
                          controller: _waterController,
                          validator: _validateWaterIntake,
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
                          controller: _systolicController,
                          validator: _validateSystolic,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText:
                                "Enter your Systiloc blood pressure (mmHg)",
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
                          controller: _diastolicController,
                          validator: _validateDiastolic,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText:
                                "Enter your Diastiloc blood pressure (mmHg)",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors().primaryColor, width: 4),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
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
                              FirebaseDb.createMedicalReport(
                                  waterIntakeLevel:
                                      int.parse(_waterController.text),
                                  systolic: int.parse(_systolicController.text),
                                  dystolic:
                                      int.parse(_diastolicController.text),
                                  context: context, time: DateTime.now());
                            }
                            _waterController.clear();
                            _systolicController.clear();
                            _diastolicController.clear();
                            
                          },
                          child: Text(
                            "Add Record",
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
