import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/controllers/home_controller.dart';
import 'package:kidneyscan/screens/report_screen.dart';
import 'package:kidneyscan/utils/snack.dart';
import 'package:kidneyscan/utils/switch_screen.dart';
import 'package:kidneyscan/utils/tips.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  pickImage(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors().secondaryColor,
      context: context,
      builder: (builder) {
        return Consumer<HomeController>(
            builder: (BuildContext context, viewModel, Widget? child) {
          return SizedBox(
            height: 30.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    viewModel.getImage(ImageSource.gallery);

                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.image,
                    size: 7.h,
                  ),
                ),
                SizedBox(
                  width: 10.h,
                ),
                InkWell(
                  onTap: () {
                    viewModel.getImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.camera_alt,
                    size: 7.h,
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, viewModel, Widget? child) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 3.h,
              ),
              Center(
                child: Card(
                  elevation: 7,
                  child: Container(
                    width: 35.h,
                    height: 15.h,
                    decoration: BoxDecoration(
                      color: AppColors().primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.h, left: 1.h, right: 1.h),
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "NOTE: ",
                              style: GoogleFonts.prompt(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors().black),
                            ),
                            TextSpan(
                              text:
                                  "Our App Serves as a valuable resource but for optimum accuracy we recommend to consulting a qualified health care professionals",
                              style: TextStyle(
                                color: AppColors().black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Card(
                elevation: 7,
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors().primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  width: 25.h,
                  height: 10.5.h,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Daily Tip: ",
                            style: GoogleFonts.prompt(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors().black,
                            ),
                          ),
                          TextSpan(
                            text: tips[4],
                            style: TextStyle(
                                color: AppColors().black,
                                overflow: TextOverflow.ellipsis),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "Upload your image",
                style: GoogleFonts.rambla(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors().primaryColor,
                ),
              ),
              SizedBox(
                height: 7.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        backgroundColor: viewModel.image != null &&
                                viewModel.image.toString() != "" &&
                                viewModel.image!.path.toString() != ""
                            ? const Color(0xff50B9DA)
                            : AppColors().grey,
                        foregroundColor: AppColors().black),
                    onPressed: () {
                      pickImage(context);
                    },
                    child: Text(
                      "Upload image",
                      style: GoogleFonts.prompt(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13),
                    child: Text(
                      viewModel.image != null &&
                              viewModel.image!.path.toString() != ""
                          ? viewModel.image!.path
                              .split('/')
                              .last
                              //.substring(0, 20)
                          : 'No file choosen',
                      style: const TextStyle(
                          fontSize: 18, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: viewModel.image != null &&
                              viewModel.image!.path.toString() != ""
                          ? const Color(0xff50B9DA)
                          : const Color(0xffE6E6E6),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  onPressed: () {
                    viewModel.image != null &&
                            viewModel.image.toString() != "" &&
                            viewModel.image!.path.toString() != "" &&
                            viewModel.image!.path
                                .split("/")
                                .last
                                .contains("jpg")
                        ? SwitchScreen().push(
                            context,
                            const ReportScreen(),
                          )
                        : snackBar(context, "the Image is not in jpg format");
                  },
                  child: Text(
                    'Generate',
                    style: GoogleFonts.prompt(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
