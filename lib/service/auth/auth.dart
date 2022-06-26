// ignore_for_file: deprecated_member_use

import 'package:chat_application_task/helper/helper_function.dart';
import 'package:chat_application_task/service/database/databse.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/user.dart';

class AuthMethods {
  final googleSiginIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  DatabaseMethods databaseMethods = DatabaseMethods();
  GoogleSignInAccount get user => _user!;
  Future googleLogin(context) async {
    try {
      final googleUser = await googleSiginIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      FirebaseAuth.instance.currentUser!.displayName;
      Map<String, String> userInfoMap = {
        "name": FirebaseAuth.instance.currentUser!.displayName as String,
        "email": FirebaseAuth.instance.currentUser!.email as String,
      };

      HelperFunctions.saveUserEmailInSharedPrefrence(
          FirebaseAuth.instance.currentUser!.displayName as String);
      HelperFunctions.saveUserNameInSharedPrefrence(
          FirebaseAuth.instance.currentUser!.displayName as String);
      databaseMethods.uploadeUserinfo(userInfoMap);

      showInSnackBar(context: context, value: "Login");
    } catch (error) {
      showInSnackBar(context: context, value: error.toString());
    }
  }

  Future logout() async {
    await googleSiginIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Usera? _userfromFirebaseUSer(User user) {
    // ignore: unnecessary_null_comparison
    return user != null ? Usera(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = res.user;
      return _userfromFirebaseUSer(firebaseUser!);
    } catch (e) {
      showInSnackBar(value: e.toString(), context: context);

      //email aready
      showInSnackBar(context: context, value: e.toString());

      // showInSnackBar("somthing went wrong");

    }
  }

  Future signUpWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? myuser = result.user;
      return _userfromFirebaseUSer(myuser!);
    } catch (e) {
      
      showInSnackBar(value: e.toString(), context: context);
      if (e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          //email aready
          showInSnackBar(context: context, value: "This Email aready exsist ");
        } else {
          showInSnackBar(context: context, value: "somthing went wrong ");
        }
      } else {
        showInSnackBar(context: context, value: e.toString());
      }
    }
  }

  Future resetPass(context, String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      showInSnackBar(context: context, value: e.toString());
    }
  }

  Future signOut(context) async {
    try {
      showInSnackBar(context: context, value: "Logout");
      return await _auth.signOut();
    } catch (e) {
      showInSnackBar(value: e.toString(), context: context);
    }
  }

  void showInSnackBar({required String value, required BuildContext context}) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
      backgroundColor: Colors.red,
    ));
  }
}
