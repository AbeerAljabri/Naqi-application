import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naqi_app/screens/devices_screen.dart';
import 'package:naqi_app/screens/home_screen.dart';
import 'package:naqi_app/screens/login_screen.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeSceen(index: 1);
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
