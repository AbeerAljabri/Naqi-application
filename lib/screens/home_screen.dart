import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naqi_app/screens/indoor_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:naqi_app/screens/settings_screen.dart';
import 'package:naqi_app/screens/indoorID.dart';
import 'package:naqi_app/screens/OutdoorID.dart';
import 'package:naqi_app/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeSceen extends StatefulWidget {
  const HomeSceen({super.key});

  @override
  State<HomeSceen> createState() => _HomeSceenState();
}

class _HomeSceenState extends State<HomeSceen>
    with AutomaticKeepAliveClientMixin {
  FirebaseService firebaseService = FirebaseService();
  SettingsPage settingsPage = SettingsPage();
  IndoorPage indoorPage = IndoorPage();
  IndoorIDPage indoorIdPage = IndoorIDPage();
  OutdoorIDPage outdoorIDPage = OutdoorIDPage();

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
    firebaseService.getUserInfo();
  }

  int index = 1;
  late final pages = [
    //هنا صفحة حسابي
    settingsPage,
    //هنا صفحة داخلي
    FutureBuilder<bool>(
      future: checkIndoorSensorID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              height: 100,
              child: Center(
                  child: Container(
                height: 100,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 135.0, left: 135),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                        strokeWidth: 4.0,
                        semanticsLabel: 'Loading',
                        semanticsValue: 'Loading',
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'بانتظار البيانات',
                        style: TextStyle(
                          color: Color(0xff45A1B6),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              )));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Handle error if any
        } else {
          final hasIndoorSensorID = snapshot.data ?? false;

          return hasIndoorSensorID ? indoorPage : indoorIdPage;
        }
      },
    ),
    //هنا صفحة خارجي
    FutureBuilder<bool>(
      future: checkOutdoorSensorID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              height: 100,
              child: Center(
                  child: Container(
                height: 100,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 135.0, left: 135),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                        strokeWidth: 4.0,
                        semanticsLabel: 'Loading',
                        semanticsValue: 'Loading',
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'بانتظار البيانات',
                        style: TextStyle(
                          color: Color(0xff45A1B6),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              )));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Handle error if any
        } else {
          final hasOutdoorSensorID = snapshot.data ?? false;

          return hasOutdoorSensorID
              ? Center(child: Text('خارجي', style: TextStyle(fontSize: 37)))
              : outdoorIDPage;
        }
      },
    ),
    //Center(child: Text('خارجي', style: TextStyle(fontSize: 37))),
    //هنا صفحة التقارير
    Center(child: Text('التقارير', style: TextStyle(fontSize: 37))),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          title: Image.asset(
            'images/IMG_1270.jpg',
            fit: BoxFit.fitWidth,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          automaticallyImplyLeading: false,
        ),
        body: pages[index],
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          height: 60,
          destinations: [
            NavigationDestination(
              icon: Container(
                height: 30,
                child: Image.asset(
                  'images/profile.png',
                  height: 30,
                ),
              ),
              label: "حسابي",
              selectedIcon: Container(
                height: 30,
                child: Image.asset(
                  'images/profile1.png',
                  height: 30,
                ),
              ),
            ),
            NavigationDestination(
              icon: Container(
                height: 30,
                child: Image.asset(
                  'images/indoor.png',
                  height: 30,
                ),
              ),
              label: "داخلي",
              selectedIcon: Container(
                height: 30,
                child: Image.asset(
                  'images/indoor1.png',
                  height: 30,
                ),
              ),
            ),
            NavigationDestination(
              icon: Container(
                height: 30,
                child: Image.asset(
                  'images/outdoor.png',
                  height: 30,
                ),
              ),
              label: "خارجي",
              selectedIcon: Container(
                height: 30,
                child: Image.asset(
                  'images/outdoor1.png',
                  height: 30,
                ),
              ),
            ),
            NavigationDestination(
              icon: Container(
                height: 30,
                child: Image.asset(
                  'images/report.png',
                  height: 30,
                ),
              ),
              label: "التقارير",
              selectedIcon: Container(
                height: 30,
                child: Image.asset(
                  'images/report1.png',
                  height: 30,
                ),
              ),
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
  Future<bool> checkIndoorSensorID() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final userData = await userDoc.get();

        if (userData.exists) {
          final userMap = userData.data() as Map<String, dynamic>;
          return userMap.containsKey('IndoorSensorID');
        }
      }
    } catch (e) {
      print('Error checking IndoorSensorID: $e');
    }

    return false;
  }

  Future<bool> checkOutdoorSensorID() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final userData = await userDoc.get();

        if (userData.exists) {
          final userMap = userData.data() as Map<String, dynamic>;
          return userMap.containsKey('OutdoorSensorID');
        }
      }
    } catch (e) {
      print('Error checking IndoorSensorID: $e');
    }

    return false;
  }
}
