import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naqi_app/firebase.dart';
import 'package:naqi_app/screens/home_screen.dart';
import 'package:naqi_app/screens/signup_screen.dart';
import 'package:naqi_app/screens/indoor_screen.dart';
import 'dart:ui';

class OutdoorIDPage extends StatefulWidget {
  OutdoorIDPage({Key? key}) : super(key: key);

  @override
  _OutdoorIDPageState createState() => _OutdoorIDPageState();
}

HomeSceen HomePage = HomeSceen(index: 2);
SignupScreen signupscreen = SignupScreen();
//IndoorPage indoorPage = IndoorPage(); هنا الاوتدور اذا زانت

class _OutdoorIDPageState extends State<OutdoorIDPage> {
  String outdoorSensorId = '';

  bool hasOutdoorSensor = false;

  bool isLoading = false;
  String errorMessage = '';

  String OutdoorButtonText = "توصيل المستشعر الداخلي";

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/outdoorhome.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        final gradient = LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black
                          ],
                          stops: [0.0, 0.8, 1.0],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        );
                        return gradient.createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset('images/outdoorhome.jpeg'),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'لا يوجد مستشعر خارجي موصول',
                      style: TextStyle(
                        fontSize: 26,
                        color: Color.fromARGB(255, 43, 138, 159),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                //the rest of the code
                Text(
                  'توصيل المستشعر',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      'معرف المستشعر الخارجي',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    infoWidget(
                        context,
                        "تستطيع إيجاد المعرف على المستشعر في الأسفل",
                        'images/IMG_1270.jpg'),
                  ],
                ),
                SizedBox(height: 8.0),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      outdoorSensorId = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'أدخل معرف المستشعر الخارجي',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xff45A1B6),
                    ), // Set the background color
                    foregroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 255, 255, 255),
                    ), // Set the text color
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Set the border radius
                      ),
                    ),
                  ),
                  onPressed: isLoading ? null : connectOutdoorSensor,
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Center(
                          child: Text(OutdoorButtonText),
                        ),
                ),
                SizedBox(height: 15.0),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                    ),
                  ),
                ElevatedButton.icon(
                  onPressed: (hasOutdoorSensor)
                      ? () => navigateToIndoorAirQualityPage(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 84, 185, 146),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Adjust the border radius
                    ),
                  ),
                  icon: Icon(
                    Icons
                        .check_circle, // Replace with a different icon if desired
                    size: 35, // Adjust the icon size
                  ),
                  label: Text(
                    'تم',
                    style: TextStyle(
                      fontSize: 25, // Adjust the font size
                      fontWeight:
                          FontWeight.bold, // Apply a different font weight
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void connectOutdoorSensor() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final QuerySnapshot sensorSnapshot = await FirebaseFirestore.instance
        .collection('Sensor')
        .where('SensorID', isEqualTo: outdoorSensorId)
        .where('Type', isEqualTo: 'O')
        .limit(1)
        .get();

    if (sensorSnapshot.docs.isNotEmpty) {
      updateInfo('OutdoorSensorID', outdoorSensorId);
      setState(() {
        hasOutdoorSensor = true;
        isLoading = false;
        OutdoorButtonText = 'تم التوصيل بنجاح';
      });
    } else {
      setState(() {
        errorMessage = 'معرف المستشعر الخارجي خاطئ';
        isLoading = false;
      });
    }
  }

  void navigateToIndoorAirQualityPage(BuildContext context) {
    // Future<bool> userStatus = checkCurrentUserStatus();
    //userStatus.then((value) {
    //   status = value;
    // });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage),
    );
  }

  //
  void updateInfo(var feild, var feildValue) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      await userRef.update({feild: feildValue});
      setState(() {
        feild = feildValue;
      });
    }
  }
}

Widget infoWidget(BuildContext context, String text, String imageUrl) {
  return IconButton(
    onPressed: () {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Image.asset(
                      imageUrl,
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 10),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'حسناً',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 43, 138, 159),
                ),
              )
            ],
          ),
        ),
      );
    },
    icon: Icon(
      Icons.info_outline,
      size: 14,
      color: Color.fromARGB(255, 107, 107, 107),
    ),
  );
}
