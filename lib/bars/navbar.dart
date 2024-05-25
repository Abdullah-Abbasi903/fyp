import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidneyscan/bars/drawer.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/controllers/theme_controller.dart';
import 'package:kidneyscan/screens/blog_screen.dart';
import 'package:kidneyscan/screens/home_screen.dart';
import 'package:kidneyscan/screens/input_data.dart';
import 'package:kidneyscan/screens/report_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NavBar extends StatefulWidget {
  NavBar({super.key});


  
  final auth = FirebaseAuth.instance;
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  void dispose() {
    _controller.dispose(); // Dispose of the AnimationController
    _pageController.dispose(); // Dispose of the PageController
    super.dispose();
  }

  final List<Widget> bottomBarPages = [
    const HomeScreen(),
    const ReportScreen(),
    const InputData(),
    const BlogScreen(),
  ];

  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 4;

  final _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: AppColors().white,
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
            backgroundColor: value.primaryColor(context),
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
                  color: value.primaryColor(context),
                  showLabel: false,
                  shadowElevation: 5,
                  kBottomRadius: 28.0,
                  notchColor: value.primaryColor(context),
                  removeMargins: false,
                  bottomBarWidth: 500,
                  showShadow: false,
                  durationInMilliSeconds: 300,
                  elevation: 1,
                  bottomBarItems: [
                    BottomBarItem(
                      inActiveItem: SvgPicture.asset(
                        "assets/svgs/homea.svg",
                      ),
                      activeItem: SvgPicture.asset(
                        "assets/svgs/homei.svg",
                        colorFilter: ColorFilter.mode(
                          value.secpondaryColor(context),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    BottomBarItem(
                      inActiveItem:
                          SvgPicture.asset("assets/svgs/report_i.svg"),
                      activeItem: SvgPicture.asset("assets/svgs/report_a.svg",
                          colorFilter: ColorFilter.mode(
                          value.secpondaryColor(context),
                          BlendMode.srcIn,
                        ),),
                    ),
                     BottomBarItem(
                      inActiveItem: Image.asset(
                        "assets/images/unselected care.png",
                        color: Colors.white,
                      ),
                      activeItem: Image.asset(
                        "assets/images/selected care.png",
                        // color: Colors.white,
                        // colorFilter: ColorFilter.mode(
                        //   value.secpondaryColor(context),
                        //   BlendMode.srcIn,
                        // ),
                      ),
                    ),
                    BottomBarItem(
                      inActiveItem: SvgPicture.asset("assets/svgs/blog_i.svg"),
                      activeItem: SvgPicture.asset("assets/svgs/blog_a.svg",
                          colorFilter: ColorFilter.mode(
                          value.secpondaryColor(context),
                          BlendMode.srcIn,
                        ),),
                    ),
                  ],
                  onTap: (index) {
                    _pageController.jumpToPage(index);
                  },
                  kIconSize: 24.0,
                )
              : null,
          drawer: MyDrawer(userEmail: widget.auth.currentUser?.email ?? ''),
        );
      },
    );
  }
}
