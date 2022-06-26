import 'package:chat_application_task/helper/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'helper/authanticate.dart';
import 'helper/helper_function.dart';
import 'screens/views/chat_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPrefrence().then((value) {
      setState(() {
        if (value != null) {
          userIsLoggedIn = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Application',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.scafooldBackGroundColor,
        primarySwatch: Colors.blue,
      ),
      home: userIsLoggedIn ? const ChatRoom() : const Authanticate(),
    );
  }
}
