

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kidneyscan/model/user_model.dart';
import 'package:kidneyscan/utils/snack.dart';

class FirebaseDb {
  static CollectionReference user =
      FirebaseFirestore.instance.collection("users");
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
        // Email already exists, return false
        return false;
      }
      ////////////////////////////////////////////////////////
      UserCredential userDate = await auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
      addUsertoDb(
          userEmail: userEmail, userName: userName, userNumber: userNumber);
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

    final encode = UserModel(
      name: userName,
      number: userNumber,
      email: userEmail,
      uId: userId,
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
      // Show snackbar with generic error message
      snackBar(context, "An error");
      return false;
    }
  }

  static Future<void> recover({required String userEmail}) async {
    await auth.sendPasswordResetEmail(email: userEmail);
  }

  static Future<bool> signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
   
      print("some error occured $e");
      rethrow;
    }
  }
}
