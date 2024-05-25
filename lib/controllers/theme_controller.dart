import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';


import '../model/user_model.dart';

class ThemeController extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();

  ThemeData get currentTheme => _currentTheme;

  Color primaryColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.black : const Color(0xff53C5DE);
  }

  Color secpondaryColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.white : AppColors().black;
  }

Color thirdColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? AppColors().darkGrey : AppColors().grey;
  }
  UserData? get user => _user;
  UserData? _user;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? _image;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  String? get image => _image;
  Future<void> getUser(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _fireStore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        _user = UserData.fromJson(snapshot.data()!);
        notifyListeners();
        print('____________Data__________');
        print(_user!.email.toString());
        if (user != null) {
          nameController.text = user!.name!;
          // emailController.text = user!.email;
          phoneController.text = user!.phoneNumber!;
          print('__________ph____-${user!.phoneNumber}');
          _image = user!.profilePic;
        }
        print('____________Email__________');
        print(user!.profilePic);
        notifyListeners();
      } else {
        _user = null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      _user = null;
    }
  }

  void toggleTheme() async {
    _currentTheme = _currentTheme == ThemeData.light()
        ? ThemeData.dark()
        : ThemeData.light();

    notifyListeners();
  }
}
