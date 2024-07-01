import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/controllers/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController toController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messegeController = TextEditingController();
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
  void launchEmail(  {required String toEmail,
    required String subject,
    required String message,}) async {

// ···
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: toEmail,
      query: encodeQueryParameters({

        'subject':subject,
        'body': message,
      }),
    );

    launchUrl(emailLaunchUri);
  }
  // Future<void> launchEmail({
  //   required String toEmail,
  //   required String subject,
  //   required String message,
  // }) async {
  //   final emailUri = Uri(
  //     scheme: 'mailto',
  //     path: toEmail,
  //     queryParameters: {
  //       'subject': subject,
  //       'body': message,
  //     },
  //   );
  //
  //   final emailUrl = emailUri.toString();
  //
  //   try {
  //     if (await canLaunch(emailUrl)) {
  //       await launch(emailUrl);
  //     } else {
  //       throw 'Could not launch $emailUrl';
  //     }
  //   } catch (e) {
  //     print('Error launching email: $e');
  //     throw e;
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Provider.of<ThemeController>(context, listen: false)
              .primaryColor(context),
          toolbarHeight: 12.h,
          centerTitle: true,
          title: Text(
            "Kidney Scan",
            style: GoogleFonts.pacifico(
              fontSize: 35,
              color: AppColors().white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 6.h),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'TO',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors().black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextFormField(
                  controller: toController,
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: "abbasiabdullah672@gmail.com",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: AppColors().primaryColor,
                    )),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Subject',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors().black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextFormField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    hintText: "Enter Subject",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: AppColors().primaryColor,
                    )),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Messege',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors().black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextFormField(
                  controller: messegeController,
                  maxLines: 7,
                  decoration: InputDecoration(
                    hintText: "Enter Your Messege",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: AppColors().primaryColor,
                    )),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  width: 20.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().primaryColor,
                        foregroundColor: AppColors().black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      const hintText = "abbasiabdullah672@gmail.com";
                      launchEmail(
                        toEmail: hintText,
                        subject: subjectController.text,
                        message: messegeController.text,
                      );
                    },
                    child: const Text("Send"),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
