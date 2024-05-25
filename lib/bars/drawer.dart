import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kidneyscan/controllers/theme_controller.dart';
import 'package:kidneyscan/database/firebase_db.dart';
import 'package:kidneyscan/keys/app_keys.dart';
import 'package:kidneyscan/screens/login_screen.dart';
import 'package:kidneyscan/screens/medical_history_screen.dart';
import 'package:kidneyscan/screens/update_profile.dart';
import 'package:kidneyscan/utils/switch_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MyDrawer extends StatefulWidget {
  const MyDrawer({required this.userEmail, super.key});

  final String userEmail;
 
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool buttonValue = false;
  String userName = '';

  @override
  void initState() {
    
    super.initState();
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ThemeController>(context, listen: false).getUser(currentUserId);
    });
    loadSwitchState();
  }

 setTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Store the current theme mode in shared preferences
    await prefs.setBool('isDarkMode', value);
    // Update the switch state
    setState(() {
      buttonValue = value;
    });
  }

  loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // If the 'isDarkMode' key doesn't exist, default to false (light mode)
      buttonValue = prefs.getBool('isDarkMode') ?? false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, viewModel, child) {
        return Drawer(
          backgroundColor: viewModel.primaryColor(context),
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [

              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: viewModel.primaryColor(context)),
                accountName: Text(
                viewModel.user != null  ?
                  viewModel.user!.name.toString()  : "",
                  style: TextStyle(color:viewModel.secpondaryColor(context), fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  viewModel.user != null ? viewModel.user!.email.toString() : "",
                  style: TextStyle(color: viewModel.secpondaryColor(context)),
                ),
                currentAccountPicture: CircleAvatar(
                  radius: 50,
                  backgroundImage: viewModel.image != null
                      ? NetworkImage(viewModel.image.toString())
                      :  const NetworkImage(
                      'https://png.pngtree.com/png-vector/20191101/ourmid/pngtree-cartoon-color-simple-male-avatar-png-image_1934459.jpg'),
                  // borderRadius: BorderRadius.circular(100),
                  // child: CachedNetworkImage(
                  //   imageUrl: value.image.toString(),
                  //   placeholder: (context, url) => Icon(Icons.person),
                  //   errorWidget: (context, url, error) => Icon(Icons.error),
                  // ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text("profile"),
                onTap: () {
                  SwitchScreen().push(context,  const UpdateProfile());
                },
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
                    setTheme(value);
                  },
                  value: buttonValue,
                ),
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
                leading: const Icon(Icons.local_hospital),
                title: const Text("Medical History"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const MedicalHistoryScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text("Notification"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirm Logout'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              SharedPreferences prefs= await SharedPreferences.getInstance();
                              prefs.setBool(AppKeys.loginKey, false);
                              await FirebaseDb.logOut();
                              Navigator.pop(context);
                              Future.delayed(const Duration(seconds: 1));
                              SwitchScreen().pushReplace(context, const LoginScreen());
                            },
                            child: const Text('Confirm'),
                          )
                        ],
                      );
                    },
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
