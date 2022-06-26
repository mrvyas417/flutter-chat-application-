// ignore_for_file: await_only_futures

import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPrefrenceUserLoggedInKey = 'ISLOGGEDIN';
  static String sharedPrefrenceUserNameKey = 'USERNAMEKEY';
  static String sharedPrefrenceUserEmailKey = 'USEREMAILKEY';
  //saving data to shared prefrence

  static Future<bool> saveUserLoggedInSharedPrefrence(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPrefrenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<dynamic> saveUserNameInSharedPrefrence(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefrenceUserNameKey, userName);
  }

  static Future<dynamic> saveUserEmailInSharedPrefrence(
      String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefrenceUserEmailKey, userEmail);
  }

  //getting data From SharedPrefrence
  static Future<bool?> getUserLoggedInSharedPrefrence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPrefrenceUserLoggedInKey);
  }

  static Future<String?> getUserNameInSharedPrefrence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefrenceUserNameKey);
  }

  static Future<String?> getUserEmailInSharedPrefrence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefrenceUserEmailKey);
  }

  static Future clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
