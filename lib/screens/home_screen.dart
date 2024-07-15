import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/controllers/home_controller.dart';
import 'package:kidneyscan/controllers/internet_controller.dart';
import 'package:kidneyscan/controllers/theme_controller.dart';
import 'package:kidneyscan/screens/report_screen.dart';
import 'package:kidneyscan/utils/snack.dart';
import 'package:kidneyscan/utils/switch_screen.dart';
import 'package:kidneyscan/utils/tips.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../model/kidney_model.dart';
import '../repo/model_repo.dart';

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
        return Consumer<HomeController>(builder: (BuildContext context, viewModel, Widget? child) {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ThemeController>(context, listen: false).getUser();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, viewModel, Widget? child) {
        return Scaffold(
          backgroundColor: AppColors().white,
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
                  : Consumer<ThemeController>(
                      builder: (context, themeValue, child) {
                        return Column(
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
                                    color: themeValue.primaryColor(context),
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
                                              color: themeValue.secpondaryColor(context),
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "Our App Serves as a valuable resource but for optimum accuracy we recommend to consulting a qualified health care professionals",
                                            style: TextStyle(
                                              color: themeValue.secpondaryColor(context),
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
                                decoration: BoxDecoration(color: themeValue.primaryColor(context), borderRadius: BorderRadius.circular(10)),
                                width: 25.h,
                                height: 10.5.h,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
                                  child: RichText(
                                    textAlign: TextAlign.justify,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Daily Tip: ",
                                          style: GoogleFonts.prompt(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: themeValue.secpondaryColor(context),
                                          ),
                                        ),
                                        TextSpan(
                                          text: kidneyCareTips[4],
                                          style: TextStyle(color: themeValue.secpondaryColor(context), overflow: TextOverflow.ellipsis),
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
                                color: themeValue.primaryColor(context),
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
                                          ? themeValue.currentTheme == ThemeData.dark()
                                              ? themeValue.thirdColor(context)
                                              : AppColors().primaryColor
                                          : AppColors().grey,
                                      foregroundColor: AppColors().black),
                                  onPressed: () {
                                    pickImage(context);
                                  },
                                  child: Text(
                                    "Upload image",
                                    style: GoogleFonts.prompt(
                                      color: themeValue.currentTheme == ThemeData.dark() ? AppColors().black : AppColors().black,
                                      // themeValue.secpondaryColor(context),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: SizedBox(
                                    width: 15.h,
                                    child: Text(
                                      viewModel.image != null && viewModel.image!.path.toString() != ""
                                          ? viewModel.image!.path.split('/').last
                                          //.substring(0, 30)
                                          : 'No file choosen',
                                      style: TextStyle(
                                          color: themeValue.currentTheme == ThemeData.dark() ? AppColors().black : AppColors().black,
                                          fontSize: 17,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            viewModel.loading
                                ? Container(
                                    width: 300,
                                    height: 50,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors().primaryColor,
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    width: 200,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: viewModel.image != null && viewModel.image!.path.toString() != ""
                                              ? themeValue.currentTheme == ThemeData.dark()
                                                  ? themeValue.thirdColor(context)
                                                  : AppColors().primaryColor
                                              : AppColors().grey,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          )),
                                      onPressed: viewModel.image != null &&
                                              viewModel.image.toString() != "" &&
                                              viewModel.image!.path.toString() != "" &&
                                              viewModel.image!.path.split("/").last.contains("jpg")
                                          ? () async {
                                              print('_____________________BTN_________________');
                                              viewModel.apiCall(viewModel.image!,context);
                                            }
                                          : () {
                                              snackBar(context, "Please provide correct image format");
                                            },
                                      child: Text(
                                        'Generate',
                                        style: GoogleFonts.prompt(
                                          fontWeight: FontWeight.bold,
                                          color: themeValue.currentTheme == ThemeData.dark() ? AppColors().black : AppColors().black,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        );
                      },
                    );
            },
          ),
        );
      },
    );
  }
}
