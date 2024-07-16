import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kidneyscan/model/user_model.dart';
import 'package:kidneyscan/utils/snack.dart';

import '../bars/navbar.dart';
import '../constants/colors/app_colors.dart';
import '../utils/switch_screen.dart';

class FirebaseDb {
 
  

  static CollectionReference user =
      FirebaseFirestore.instance.collection("users");

    



static createMedicalReport({required int waterIntakeLevel,required int systolic,required int dystolic,required BuildContext context,required DateTime time}) async {
String userId = auth.currentUser!.uid;
  await user.doc(userId).collection("medicalReports").add({
    "waterIntakeLevel":waterIntakeLevel,
    "systolic BP":systolic,
    "dystolic BP":dystolic,
    'time':time
  });
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Report Added"),duration: Duration(seconds: 1),));
}

  static final auth = FirebaseAuth.instance;

  static Future<bool> createUser({
    required userPassword,
    required userEmail,
    required userName,
    required userNumber,
  }) async {
    try {
      var userExists = await user.where('email', isEqualTo: userEmail).get();

      if (userExists.docs.isNotEmpty) {
        return false;
      }
      ////////////////////////////////////////////////////////
      UserCredential userDate = await auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
      addUsertoDb(
          userEmail: userEmail, userName: userName, userNumber: userNumber,);
      return true;
    } catch (e) {
      //print("Some error ocurred $e");
      return false;
    }
  }

  static Future<void> addUsertoDb({
    required userEmail,
    required userName,
    required userNumber,
  }) async {
    String userId = auth.currentUser!.uid;

    final encode = UserData(
      name: userName,

      email: userEmail,
      uId: userId, phoneNumber: userNumber, profilePic: 'https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png',
    );

    final getData = encode.toJson();

    await user.doc(userId).set(getData).then((value) {
      print("user added successfully ");
    }).catchError((error) {
      print("error occired $error");
    });
    //print("Some error ocurred $e");
  }

  static Future<bool> getUser({
    required BuildContext context,
    required String userEmail,
    required String userPassword,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      snackBar(context, e.message ?? "An error occurred");
      return false;
    } catch (e) {
     
      snackBar(context, "An error");
      return false;
    }
  }

  static Future<void> recover({required String userEmail}) async {
    await auth.sendPasswordResetEmail(email: userEmail);
  }

  static FirebaseAuth ar = FirebaseAuth.instance;
  static GoogleSignIn googleSignIn = GoogleSignIn(

  );

  static Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn(

    );
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      final UserCredential userCredential = await ar.signInWithCredential(credential);
      final User? user = userCredential.user;
    print("______________");
    print('${user!.email}');
      snackBar(
          context,
          "User Registered Successfully",
          AppColors().primaryColor);
      Future.delayed(
        const Duration(seconds: 2),
            () {
          SwitchScreen()
              .pushReplace(context, NavBar());
        },
      );
    } catch (e) {
      print("Error: $e");
    }
    // }
    // static Future<bool> signInWithGoogle() async {
    // Trigger the authentication flow
    //   try {
    //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    //
    //     // Obtain the auth details from the request
    //     final GoogleSignInAuthentication? googleAuth =
    //         await googleUser?.authentication;
    //
    //     // Create a new credential
    //     final credential = GoogleAuthProvider.credential(
    //       accessToken: googleAuth?.accessToken,
    //       idToken: googleAuth?.idToken,
    //     );
    //
    //     // Once signed in, return the UserCredential
    //    final res =  await FirebaseAuth.instance.signInWithCredential(credential);
    //     if(res.user != null){
    //       print('_______________google_signin___________');
    //       print(res.user!.email.toString());
    //       print(res.user!.phoneNumber.toString());
    //       print(res.user!.displayName.toString());
    //       }
    //     return true;
    //   } catch (e) {
    //     print("some error occured $e");
    //     rethrow;
    //   }
    // }
  }
  static Future<String?> getUserName(String userEmail) async {
    try {
      var userData = await user.where('email', isEqualTo: userEmail).get();
      if (userData.docs.isNotEmpty) {
        var firstDoc = userData.docs.first;
        if (firstDoc.exists) {
          var userDataMap = firstDoc.data() as Map<String, dynamic>?;
          if (userDataMap != null && userDataMap.containsKey('name')) {
            return userDataMap['name'] as String?;
          }
        }
      }
      return null;
    } catch (e) {
      print("Error fetching user name: $e");
      return null;
    }
  }
  
  static Future<void> logOut() async {
    try {
      await auth.signOut();
      
    } catch (e) {
       print('Error logging out user: $e');
       rethrow;
    }
  }
}
