import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/controllers/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

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
    );
  }
}
