import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kidneyscan/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


class DbController extends ChangeNotifier {
  // DbController() {
  //   // getUserInfo();
  // }
  String? _image;

  String? get image => _image;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var auth = FirebaseAuth.instance.currentUser!.uid;

  bool _getting = false;

  bool get getting => _getting;

  UserData? get user => _user;
  UserData? _user;

  Future<void> getUser(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _fireStore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        _user = UserData.fromJson(snapshot.data()!);
        notifyListeners();
        print('____________Data__________');
        print(_user!.email.toString());
        if (user != null) {
          nameController.text = user!.name;
          // emailController.text = user!.email;
          phoneController.text = user!.phoneNumber;
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

//   Future<void> getUserInfo() async {
//     DocumentSnapshot<Map<String, dynamic>> snapshot =
//         await FirebaseFirestore.instance.collection("users").doc(auth).get();
//     _data = UserData.fromJson(snapshot.data()!);
//     notifyListeners();
//     if (_data != null) {
//       email.text = _data!.email;
// _image = _data!.profilePic;
//       name.text = _data!.name;
//       number.text = _data!.phoneNumber;
//     }
//     notifyListeners();
//     //  if(_data!=null){
//     //     print("name: ${_data!.name}");
//     //     print("emai: ${_data!.email}");
//     //     print("number: ${_data!.phoneNumber}");
//   }

  // Future<void> updateUserInfo(UserData userData) async {
  //   try {
  //     _getting = true;
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(auth)
  //         .update(userData.toJson());
  //     // Update local data after successful update
  //     _uInfo = userData;
  //     _getting = false;
  //     notifyListeners();
  //     print("User info updated successfully!");
  //   } catch (error) {
  //     print("Error updating user info: $error");
  //   }
  // }

  Future<String?> uploadImageToFirebaseStorage(File imageFile, String userId) async {
    try {
      String storagePath = 'profile_pictures/$userId.jpg'; // Change the path as needed
      Reference storageReference = FirebaseStorage.instance.ref().child(storagePath);
      await storageReference.putFile(imageFile);
      String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> updateProfilePictureUrl(String userId, String imageUrl) async {
    try {
      await _fireStore.collection('users').doc(userId).update({
        'profilePictureUrl': imageUrl,
      });
    } catch (e) {
      print('Error updating profile picture URL: $e');
    }
  }

  Future<void> updateUser(UserData updatedUser, BuildContext context) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    try {
      if (_validateUserData(updatedUser, context)) {
        await _fireStore.collection('users').doc(currentUserId).update({
          'name': nameController.text,
          'phoneNumber': phoneController.text,
        });
        _user = updatedUser;
        notifyListeners();
        getUser(currentUserId);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated"), duration: Duration(seconds: 2)));
        notifyListeners();
      }
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  bool _validateUserData(UserData user, context) {
    if (user.name!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Name cannot be empty"),
        duration: Duration(seconds: 1),
      ));
      return false;
    }
    if (user.phoneNumber!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Name cannot be empty"),
        duration: Duration(seconds: 1),
      ));
      return false;
    }
    return true;
  }

  Future<void> changeEmail(String currentEmail, String password, String newEmail) async {
    try {
      // Sign in the user with their current credentials
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: currentEmail,
        password: password,
      );

      // Update the email address
      await userCredential.user!.verifyBeforeUpdateEmail(newEmail);

      // Optionally, you might want to reauthenticate the user if needed
      // await userCredential.user.reauthenticateWithCredential(
      //   EmailAuthProvider.credential(email: currentEmail, password: password),
      // );

      // Optionally, you can sign out the user after updating the email
      // await FirebaseAuth.instance.signOut();

      print("Email updated successfully");
    } catch (e) {
      print("Failed to update email: $e");
      // Handle errors here
    }
  }
}
