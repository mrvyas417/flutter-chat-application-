// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, prefer_const_constructors

import 'package:chat_application_task/helper/colors.dart';
import 'package:chat_application_task/screens/views/chat_main.dart';
import 'package:chat_application_task/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../../service/auth/auth.dart';
import '../../service/database/databse.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

   const SignIn(this.toggle, {Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  bool isLoading = false;
  QuerySnapshot? snapshotUserInfo;
  signIn() {
    if (formkey.currentState!.validate()) {
      HelperFunctions.saveUserEmailInSharedPrefrence(email.text);
      databaseMethods.getUsersByEmail(email: email.text).then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameInSharedPrefrence(
          snapshotUserInfo!.docs[0].get('name'),
        );
      });
      //
      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(
              context: context, password: password.text, email: email.text)
          .then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPrefrence(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(BuildContext, context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!)
                              ? null
                              : "Enter correct email";
                        },
                        controller: email,
                        style: simpleTextField(),
                        decoration: textFieldInputDecoration(hint: "Email"),
                      ),
                      TextFormField(
                        validator: (value) {
                          return value!.length > 6
                              ? null
                              : "Please provide password 6+ charcter";
                        },
                        controller: password,
                        obscureText: true,
                        style: simpleTextField(),
                        decoration: textFieldInputDecoration(hint: "Password"),
                      ),
                    ],
                  ),
                ),
               const  SizedBox(
                  height: 8,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Forgot Password ?",
                      style: simpleTextField(),
                    ),
                  ),
                ),
               
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          AppColors.issendGradient1,
                          AppColors.issendGradient2
                        ]),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      "Sign In",
                      style: simpleTextField(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InkWell(
                    onTap: () async {
                      await authMethods.googleLogin(context);

                      HelperFunctions.saveUserLoggedInSharedPrefrence(true);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatRoom()));
                    },
                    child: const Text(
                      "Sign In With Google",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account ? ",
                      style: simpleTextField(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        child: const Text(
                          " Register Now",
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
