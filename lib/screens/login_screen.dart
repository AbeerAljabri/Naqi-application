import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:naqi_app/screens/forgot_pw_reset.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
  bool isSnackBarVisible =
      false; // Add this variable to track the Snackbar visibility

  void openSignupScreen() {
    Navigator.of(context).pushReplacementNamed('signupScreen');
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && isAlertSet == false) {
          showDialogBox();
          setState(() => isAlertSet = true);
        }
      },
    );
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
                    mainAxisAlignment: MainAxisAlignment.end,
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
                        if (_key.currentState!.validate()) {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          )
                              // ignore: body_might_complete_normally_catch_error
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

  showDialogBox() {
    final scaffold = ScaffoldMessenger.of(context);

    if (!isSnackBarVisible) {
      // Check if the Snackbar is not already visible
      scaffold.showSnackBar(
        SnackBar(
          content:
              Text("لا يوجد اتصال بالانترنت\nالرجاء التحقق من اتصال الانترنت"),
          backgroundColor: Colors.black, // Set the background color to black
          duration:
              Duration(seconds: 9999), // Set the duration to a large value
          action: SnackBarAction(
            label: 'حسنًا',
            onPressed: () async {
              //scaffold.hideCurrentSnackBar();
              setState(() => isAlertSet = false);
              isDeviceConnected =
                  await InternetConnectionChecker().hasConnection;
              if (!isDeviceConnected) {
                setState(() {
                  isAlertSet = true;
                  isSnackBarVisible =
                      false; // Set the flag to false when Snackbar is hidden
                });
              }
            },
          ),
        ),
      );

      setState(() => isSnackBarVisible =
          true); // Set the flag to true when showing the Snackbar
    }
  }

/* showDialogBox() {
  final scaffold = ScaffoldMessenger.of(context);

  if (!isSnackBarVisible) {
    // Check if the Snackbar is not already visible
    scaffold.showSnackBar(
      SnackBar(
        content: Text("لا يوجد اتصال بالانترنت\nالرجاء التحقق من اتصال الانترنت"),
        backgroundColor: Colors.black, // Set the background color to red
        action: SnackBarAction(
          label: 'حسنًا',
          onPressed: () async {
            //scaffold.hideCurrentSnackBar();
            setState(() => isAlertSet = false);
            isDeviceConnected = await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected) {
              setState(() {
                isAlertSet = true;
                isSnackBarVisible = false; // Set the flag to false when Snackbar is hidden
              });
            }
          },
        ),
      ),
    );

    setState(() => isSnackBarVisible = true); // Set the flag to true when showing the Snackbar
  }
}*/
}
