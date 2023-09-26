import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naqi_app/firebase.dart';
import 'package:naqi_app/screens/home_screen.dart';
import 'package:naqi_app/screens/signup_screen.dart';

import '../internetConnection.dart';

class DevicesPage extends StatefulWidget {
  DevicesPage({Key? key}) : super(key: key);

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

SignupScreen signupscreen = SignupScreen();
internetConnection connection = internetConnection();
String errorMessage = '';

class _DevicesPageState extends State<DevicesPage> {
  String originalIndoorID = FirebaseService.indoorSensorID ?? "";
  String originalOutdoorID = FirebaseService.outdoorSensorID ?? "";
  String updatedIndoor = '';
  String updatedOutdoor = '';
  bool changesMade = false; // Add a boolean variable to track changes
  bool isButtonEnabled = false; // Add a boolean variable to track button state

// internetConnection connection = internetConnection();
  @override
  void initState() {
    super.initState();
    isButtonEnabled = false;
  }

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

  void updateIndoorSensor() async {
    setState(() {
      errorMessage = '';
    });

    final QuerySnapshot sensorSnapshot = await FirebaseFirestore.instance
        .collection('Sensor')
        .where('SensorID', isEqualTo: updatedIndoor)
        .where('Type', isEqualTo: 'I')
        .limit(1)
        .get();

    if (sensorSnapshot.docs.isNotEmpty) {
      updateInfo('IndoorSensorID', updatedIndoor);
      FirebaseService.indoorSensorID = updatedIndoor;
    } else {
      setState(() {
        errorMessage = 'معرف المستشعر الداخلي خاطئ';
      });
      // return; // Add a return statement to exit the method if the sensor is incorrect
    }
  }

  void updateOutdoorSensor() async {
    setState(() {
      errorMessage = '';
    });
    final QuerySnapshot sensorSnapshot = await FirebaseFirestore.instance
        .collection('Sensor')
        // .where('SensorID', isEqualTo: outdoorSensorId)
        .where('Type', isEqualTo: 'O')
        .limit(1)
        .get();

    if (sensorSnapshot.docs.isNotEmpty) {
      // updateInfo('OutdoorSensorID', outdoorSensorId);

      setState(() {});
    } else {
      setState(() {
        errorMessage = 'معرف المستشعر الخارجي خاطئ';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' معلومات أجهزتي ',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('معرف المستشعر الداخلي',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.email),
                          title: Text(
                            originalIndoorID,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                /*Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'معرف المستشعر الداخلي',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                          height:
                              5), // Adjusted the SizedBox height for better spacing

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(
                              8.0), // Simplified BorderRadius
                        ),
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: TextFormField(
                            initialValue:
                                originalIndoorID, // Use the original value
                            onChanged: (newValue) {
                              setState(() {
                                updatedIndoor =
                                    newValue; // Update the original value locally
                                changesMade =
                                    true; // Set changesMade to true when changes are made
                                isButtonEnabled = newValue
                                    .isNotEmpty; // تحقق من عدم فراغ القيمة
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none, // Hide the underline
                            ),
                            textDirection: TextDirection
                                .rtl, // Force right-to-left direction
                            textAlign:
                                TextAlign.start, // Align to the start (left)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),*/

                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('معرف المستشعر الخارجي',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.email),
                          title: Text(
                            originalOutdoorID,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // Adjusted the SizedBox height for better spacing
                ElevatedButton(
                  onPressed: (isButtonEnabled &&
                          originalIndoorID != null &&
                          originalIndoorID.isNotEmpty)
                      ? () async {
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

                          // Perform the save operation
                          if (updatedIndoor != null &&
                              updatedIndoor.isNotEmpty) {
                            updateIndoorSensor();
                            //FirebaseService.indoorSensorID = updatedIndoor;
                            //updateInfo('firstName', originalFirstName);
                          }

                          // After updating Firestore, show a success message
                          if (errorMessage.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                FocusScope.of(context)
                                    .unfocus(); // Hide the keyboard
                                return AlertDialog(
                                  title: Text('تم الحفظ بنجاح'),
                                  content: Text('تم حفظ التغييرات بنجاح.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          isButtonEnabled =
                                              false; // Disable the button after successful save
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        primary: Colors.blue,
                                      ),
                                      child: Text('حسنًا'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                FocusScope.of(context)
                                    .unfocus(); // Hide the keyboard
                                return AlertDialog(
                                  title: Text('خطأ'),
                                  content: Text(errorMessage),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                        primary: Colors.red,
                                      ),
                                      child: Text('حسنًا'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      : null,
                  child: Text(
                    'حفظ التغييرات',
                    style: TextStyle(
                      color: (isButtonEnabled &&
                              originalIndoorID != null &&
                              originalIndoorID.isNotEmpty)
                          ? Colors.white
                          : Colors.grey[700],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 43, 138, 159),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),

                SizedBox(height: 30),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
