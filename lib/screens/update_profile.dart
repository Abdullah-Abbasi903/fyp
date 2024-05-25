import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kidneyscan/bars/top_bar.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/controllers/db_controller.dart';
import 'package:kidneyscan/controllers/theme_controller.dart';
import 'package:kidneyscan/model/user_model.dart';
import 'package:kidneyscan/screens/forgot_pass.dart';
import 'package:kidneyscan/screens/reset_email.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  File? _imageFile;
  final TextEditingController bloodPressureController =
      TextEditingController(text: 'Blood pressure');
  Future<void> pickImage(ImageSource source) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      if (_imageFile != null) {
        uploadAndSetProfilePicture(currentUserId);
        // _controller.getUser(currentUserId);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DbController>(context, listen: false).getUser(currentUserId);
    });
  }

  final DbController _controller = DbController();

  Future<void> uploadAndSetProfilePicture(String userId) async {
    if (_imageFile != null) {
      String? imageUrl =
          await _controller.uploadImageToFirebaseStorage(_imageFile!, userId);
      if (imageUrl != null) {
        await _controller.updateProfilePictureUrl(userId, imageUrl);
        // Show a success message or navigate to another screen
      } else {
        // Handle error while uploading image
      }
    } else {
      // Show error message that no image is selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DbController>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Consumer<ThemeController>(
            builder: (context, value, child) {
              return Column(
                children: [
                  SizedBox(
                    height: 30.h,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 15.8.h,
                          child: const TopBar(),
                        ),
                        Positioned(
                          left: 17.h,
                          bottom: 2.7.h,
                          child: GestureDetector(
                            onTap: () {
                              pickImage(ImageSource.camera);
                            },
                            child: Container(
                              width: 14.h,
                              height: 13
                                  .h, // Set a fixed height to ensure proper sizing
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white,
                                    width: 2), // Add a border to the circle
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 10.h,
                                backgroundImage: value.image != null
                                    ? NetworkImage(value.image.toString())
                                    : const NetworkImage(
                                        'https://png.pngtree.com/png-vector/20191101/ourmid/pngtree-cartoon-color-simple-male-avatar-png-image_1934459.jpg'),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Text(
                  //   "Muhammad Abdullah Abbasi",
                  //   style:
                  //       GoogleFonts.prompt(fontSize: 20, fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(
                  //   height: 1.h,
                  // ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: value.nameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: "Your Name",
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          TextFormField(
                            controller: value.phoneController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.call),
                              hintText: "Number",
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ForgotPass(),
                                ),
                              );
                            },
                            child: TextFormField(
                                enabled: false,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.remove_red_eye),
                                  hintText: "Password",
                                ),
                                obscureText: true),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ResetEmailScreen(),
                                ),
                              );
                            },
                            child: TextFormField(
                                enabled: false,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.mail),
                                  hintText: "Email",
                                ),
                                obscureText: true),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          viewModel.getting
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        value.currentTheme == ThemeData.dark()
                                            ? AppColors().darkGrey
                                            : AppColors().primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    String currentUserId =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    viewModel.updateUser(
                                        UserData(
                                            name: value.nameController.text,
                                            email: "",
                                            phoneNumber:
                                                value.phoneController.text,
                                            profilePic: value.image.toString(),
                                            uId: currentUserId),
                                        context);
                                    // value.updateUserInfo(userInfo);
                                  },
                                  child: Text(
                                    "Update Profile",
                                    style: GoogleFonts.rambla(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),

                  //  const Expanded(
                  //    child: Row(
                  //     children: [
                  //         Icon(
                  //           Icons.person,
                  //           color: Color.fromARGB(255, 122, 115, 115),
                  //         ),

                  //        TextField()
                  //     ],
                  //                ),
                  //  ),
                ],
              );
            },
          ),
          //drawer: const SideMenu(email: "testuser@gmail.com"),
        );
      },
    );
  }
}
