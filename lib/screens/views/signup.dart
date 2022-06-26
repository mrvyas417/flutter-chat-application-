// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../helper/colors.dart';
import '../../helper/helper_function.dart';
import '../../service/auth/auth.dart';
import '../../service/database/databse.dart';
import '../../widgets/widget.dart';
import 'chat_main.dart';

class Signup extends StatefulWidget {
  final Function toggle;

  const Signup(this.toggle, {Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  HelperFunctions helperFunctions = HelperFunctions();

  final formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signMeUp() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods
          .signUpWithEmailAndPassword(
              context: context, password: password.text, email: email.text)
          .then((value) {
        //print("apni value ${value.uid}");
        Map<String, String> userInfoMap = {
          "name": username.text,
          "email": email.text,
        };

        HelperFunctions.saveUserEmailInSharedPrefrence(email.text);
        HelperFunctions.saveUserNameInSharedPrefrence(username.text);
        databaseMethods.uploadeUserinfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPrefrence(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(BuildContext, context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                return value!.isEmpty || value.length < 2
                                    ? "Please Provide Username"
                                    : null;
                              },
                              controller: username,
                              style: simpleTextField(),
                              decoration:
                                  textFieldInputDecoration(hint: "Username"),
                            ),
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
                              decoration:
                                  textFieldInputDecoration(hint: "Email"),
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
                              decoration:
                                  textFieldInputDecoration(hint: "Password"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            "Forgot Password ?",
                            style: simpleTextField(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                AppColors.gradientColour1,
                                AppColors.gradientColour2,
                              ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "Sign Up",
                            style: simpleTextField(),
                          ),
                        ),
                      ),
                      const SizedBox(
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

                            HelperFunctions.saveUserLoggedInSharedPrefrence(
                                true);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ChatRoom()));
                          },
                          child: const Text(
                            "Sign Up With Google",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            " have an account ? ",
                            style: simpleTextField(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              child: const Text(
                                " Login Now",
                                style:  TextStyle(
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
