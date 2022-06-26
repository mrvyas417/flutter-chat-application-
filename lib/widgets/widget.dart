// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:chat_application_task/helper/app_images.dart';
import 'package:flutter/material.dart';

AppBarMain(BuildContext, context) {
  return AppBar(
    title: Image.asset(
      AppImages.logo,
      height: 50,
    ),
    centerTitle: true,
  );
}

InputDecoration textFieldInputDecoration({required String hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}

TextStyle simpleTextField() {
  return TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}
