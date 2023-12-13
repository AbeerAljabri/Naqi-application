import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:naqi_app/screens/forgot_pw_reset.dart';

import '../internetConnection.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  internetConnection connection = internetConnection();

  //button style
  final ButtonStyle buttonPrimary = ElevatedButton.styleFrom(
    minimumSize: Size(345, 55),
    backgroundColor: Color.fromARGB(255, 43, 138, 159),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );

  bool _isSourceLoginPaasword = true;

  void openSignupScreen() {
    Navigator.of(context).pushReplacementNamed('signupScreen');
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var child;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _key,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // image
                Image.asset(
                  'images/IMG_1270.jpg',
                  height: 200,
                ),
                SizedBox(height: 20),
                //title
                Text(
                  'تسجيل الدخول',
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),

                //subtitle
                Text(
                  ' مرحبا بك',
                  style: GoogleFonts.robotoCondensed(fontSize: 18),
                ),
                SizedBox(
                  height: 30,
                ),

                // email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: _emailController,
                    //validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,

                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: "البريد الالكتروني",

                        // ignore: prefer_const_constructors
                        prefixIcon: Icon(Icons.email)),
                    // ignore: body_might_complete_normally_nullable
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل عنوان البريد إلكتروني ';
                      } else if ((value.isNotEmpty) &&
                          !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                              .hasMatch(value)) {
                        return "الرجاء اخال عنوان بريد إلكتروني صالح";
                      }
                    },
                  ),
                ),

                SizedBox(height: 20),

                //password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: _isSourceLoginPaasword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      labelText: " كلمة المرور",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: togglePassword(),
                    ),

                    // ignore: body_might_complete_normally_nullable
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل كلمة المرور';
                      }
                    },
                  ),
                ),

                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          var push = Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return forgotPasswordPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'هل نسيت كلمة المرور؟',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text(
                        'تسجيل الدخول',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: buttonPrimary,
                      onPressed: () async {
                        // Check for internet connection
                        bool isConnected =
                            await connection.checkInternetConnection();

                        if (!isConnected) {
                          // Show a Snackbar for no internet connection
                          final scaffold = ScaffoldMessenger.of(context);
                          scaffold.showSnackBar(
                            SnackBar(
                              content: Text(
                                  "لا يوجد اتصال بالانترنت، الرجاء التحقق من الاتصال بالانترنت"),
                              duration: Duration(
                                  seconds: 5), // Set the duration as needed
                              action: SnackBarAction(
                                label: 'حسنًا',
                                onPressed: () {
                                  // Handle the action when the "OK" button is pressed
                                  scaffold.hideCurrentSnackBar();
                                },
                              ),
                            ),
                          );
                          return;
                        }

                        // Continue with the login operation
                        if (_key.currentState!.validate()) {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          )
                              .catchError((err) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("خطأ"),
                                  content: Text(
                                      "البريد الالكتروني او كلمة المرور خطأ"),
                                  actions: [
                                    TextButton(
                                      child: Text("حسنًا"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // text sign up

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ' ليس لديك حساب؟ ',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: openSignupScreen,
                      child: Text(
                        'إنشاء حساب',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  get child2 => child2;

  get child1 => child2;

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSourceLoginPaasword = !_isSourceLoginPaasword;
        });
      },
      icon: _isSourceLoginPaasword
          ? Icon(Icons.visibility)
          : Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }
}
