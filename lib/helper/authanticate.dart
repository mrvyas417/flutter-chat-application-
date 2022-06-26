// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../screens/views/signin.dart';
import '../screens/views/signup.dart';

class Authanticate extends StatefulWidget {
  const Authanticate({Key? key}) : super(key: key);

  @override
  _AuthanticateState createState() => _AuthanticateState();
}

class _AuthanticateState extends State<Authanticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Signup(toggleView);
    } else {
      return SignIn(toggleView);
    }
  }
}
