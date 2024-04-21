import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidneyscan/bars/drawer.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/screens/blog_screen.dart';
import 'package:kidneyscan/screens/home_screen.dart';
import 'package:kidneyscan/screens/report_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final List<Widget> bottomBarPages = [
    const HomeScreen(),
    const ReportScreen(),
    const BlogScreen(),
  ];

  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 3;

  final _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 12.h,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Image.asset('assets/images/side_menu.png'),
            );
          },
        ),
        backgroundColor: AppColors().primaryColor,
        centerTitle: true,
        title: Text(
          "Kidney Scan",
          style: GoogleFonts.pacifico(
            fontSize: 35,
            color: AppColors().white,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          bottomBarPages.length,
          (index) => bottomBarPages[index],
        ),
      ),
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: AppColors().primaryColor,
              showLabel: false,
              shadowElevation: 5,
              kBottomRadius: 28.0,
              notchColor: AppColors().secondaryColor,
              removeMargins: false,
              bottomBarWidth: 500,
              showShadow: false,
              durationInMilliSeconds: 300,
              elevation: 1,
              bottomBarItems: [
                BottomBarItem(
                  inActiveItem: SvgPicture.asset("assets/svgs/homea.svg"),
                  activeItem: SvgPicture.asset("assets/svgs/homei.svg"),
                ),
                BottomBarItem(
                  inActiveItem: SvgPicture.asset("assets/svgs/report_i.svg"),
                  activeItem: SvgPicture.asset("assets/svgs/report_a.svg"),
                ),
                BottomBarItem(
                  inActiveItem: SvgPicture.asset("assets/svgs/blog_i.svg"),
                  activeItem: SvgPicture.asset("assets/svgs/blog_a.svg"),
                ),
              ],
              onTap: (index) {
              
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
      drawer: const MyDrawer() 
    );
  }
}
