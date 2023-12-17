import 'package:flutter/material.dart';
import 'package:naqi_app/auth.dart';
import 'package:naqi_app/screens/home_screen.dart';
import 'package:naqi_app/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:naqi_app/screens/signup_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:naqi_app/fan.dart';
import 'package:naqi_app/screens/profile_screen.dart';
import 'package:naqi_app/screens/indoor_screen.dart';
import 'package:naqi_app/screens/devices_screen.dart';
import 'package:naqi_app/screens/healthStatus_screen.dart';

void main() async {
  Fan fan = Fan();

  fan.setUpController();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'default_channel',
          channelName: 'Basic notification',
          channelDescription: 'Notificion',
          importance: NotificationImportance.Max,
        ),
      ],
      debug: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', 'AE'), // arabic
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      routes: {
        '/': (context) => const Auth(),
        'homeScreen': (context) => HomeSceen(
              index: 1,
            ),
        'signupScreen': (context) => const SignupScreen(),
        'loginScreen': (context) => const LoginScreen(),
        'profilePage': (context) => profilePage(),
        'indoorScreen': (context) => IndoorPage(),
        'devicesScreen': (context) => DevicesPage(),
        'healthStatusScreen': (context) => healthStatusPage(),
      },
    );
  }
}
