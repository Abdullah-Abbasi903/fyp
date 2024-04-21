import 'package:flutter/material.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool buttonValue = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, viewModel, child) {
        return Drawer(
          backgroundColor: AppColors().primaryColor,
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: AppColors().primaryColor),
                accountName: Text(
                  'Muhammad Abdullah Abbasi',
                  style: TextStyle(
                      color: AppColors().black, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  'abbasiabdullah672@gmail.com',
                  style: TextStyle(color: AppColors().black),
                ),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/profile.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text("profile"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text("Dark Mode"),
                trailing: Switch(
                  onChanged: (value) {
                    setState(() {
                      buttonValue = value;
                    });
                    viewModel.toggleTheme();
                  },
                  value: buttonValue,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text("Student mode"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Contact us"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text("share"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.money),
                title: const Text("Subscription"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text("Notification"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () {},
              )
            ],
          ),
        );
      },
    );
  }
}
