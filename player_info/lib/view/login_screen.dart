import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:player_info/view/player_data_screen.dart';
import 'package:player_info/view/widget/custom_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isSignUp = false;

  bool isLogin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLogin
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isSignUp
                      ? const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Enter Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: passwordTextController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (passwordTextController.text.trim().isNotEmpty &&
                          emailTextController.text.trim().isNotEmpty) {
                        if (isSignUp) {
                          try {
                            await _firebaseAuth.createUserWithEmailAndPassword(
                              email: emailTextController.text.trim(),
                              password: passwordTextController.text,
                            );

                            CustomSnackbar.customSnackbar(
                                context: context,
                                message: "Registered Successfully");
                            passwordTextController.clear();
                            emailTextController.clear();
                            isSignUp = false;
                            setState(() {});
                          } on FirebaseAuthException catch (e) {
                            log("{${e.message}}");

                            CustomSnackbar.customSnackbar(
                                context: context, message: e.message!);
                          }
                        } else {
                          try {
                            isLogin = true;
                            setState(() {});

                            await _firebaseAuth.signInWithEmailAndPassword(
                              email: emailTextController.text,
                              password: passwordTextController.text,
                            );
                            passwordTextController.clear();
                            emailTextController.clear();

                            CustomSnackbar.customSnackbar(
                                context: context,
                                message: "Successfully Loged In");

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const PlayerDataScreen(),
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == "invalid-credential") {
                              CustomSnackbar.customSnackbar(
                                  context: context,
                                  message:
                                      "Please check your Email Id & Password");
                            }
                          } finally {
                            isLogin = false;
                            setState(() {});
                          }
                        }
                      } else {
                        CustomSnackbar.customSnackbar(
                            context: context,
                            message: "Please enter email Id & password");
                      }
                    },
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                      minimumSize: WidgetStatePropertyAll(
                        Size(double.infinity, 40),
                      ),
                    ),
                    child: isSignUp
                        ? const Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isSignUp
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            isSignUp = true;
                            setState(() {});
                          },
                          child: const Text(
                            "Don't have an account? Register",
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
