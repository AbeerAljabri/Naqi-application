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

internetConnection connection = internetConnection();
String errorMessage = '';

class _DevicesPageState extends State<DevicesPage> {
  String indoorSensorId = FirebaseService.indoorSensorID ?? "";
  String outdoorSensorId = FirebaseService.outdoorSensorID ?? "";

  FirebaseService firebaseService = FirebaseService();

  bool isInButtonEnabled = false;
  bool isOutButtonEnabled = false;

  bool newI = false;
  bool newO = false;

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

  _updateInfo(String fieldName, String newValue) async {
    // Check for internet connection
    bool isConnected = await connection.checkInternetConnection();

    if (!isConnected) {
      // Show a Snackbar for no internet connection
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
              "لا يوجد اتصال بالانترنت، الرجاء التحقق من الاتصال بالانترنت"),
          duration: Duration(seconds: 5), // Set the duration as needed
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
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Sensor')
        .where('SensorID', isEqualTo: newValue)
        .where('Type', isEqualTo: fieldName[0].toUpperCase())
        .get();

    if (snapshot.docs.isNotEmpty) {
      updateInfo(fieldName, newValue);
      setState(() {
        if (fieldName == 'IndoorSensorID') {
          indoorSensorId = newValue;
          FirebaseService.indoorSensorID = indoorSensorId;
          FirebaseService().updateIndoorSensorID(indoorSensorId);
        } else if (fieldName == 'OutdoorSensorID') {
          outdoorSensorId = newValue;
          FirebaseService.outdoorSensorID = outdoorSensorId;
        }
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          FocusScope.of(context).unfocus(); // Hide the keyboard
          return AlertDialog(
            title: Text('تم الحفظ بنجاح'),
            content: Text('تم حفظ التغييرات بنجاح.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
          return AlertDialog(
            title: Text('المعرف المدخل غير صحيح'),
            content:
                Text('المعرف المدخل غير صحيح تأكد من إدخال القيمة الصحيحة'),
            actions: [
              TextButton(
                child: Text('حسناً'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' الأجهزة ',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                labelText: 'معرف المستشعر الداخلي',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                suffixIcon: indoorSensorId.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.only(left: 8.0),
                        child: infoWidget(
                          context,
                          "تستطيع إيجاد المعرف على المستشعر في الأسفل",
                          'images/indoorSensorID.jpeg',
                        ),
                      )
                    : null,
              ),
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: indoorSensorId,
                  selection: TextSelection.fromPosition(
                    TextPosition(offset: indoorSensorId.length),
                  ),
                ),
              ),
              onChanged: (newValue) {
                setState(() {
                  indoorSensorId = newValue;
                  newI = true;
                  isInButtonEnabled = newValue.isNotEmpty;
                });
              },
              enabled: indoorSensorId
                  .isNotEmpty, // Set the enabled property based on the value of indoorSensorId
            ),
            if (indoorSensorId
                .isEmpty) // Display the message if indoorSensorId is empty
              Text(
                'لم تضف أي مستشعر بعد، تستطيع إضافة مستشعر جديد من صفحة داخلي',
                style: TextStyle(color: Color.fromARGB(255, 78, 111, 135)),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: (isInButtonEnabled &&
                      isInButtonEnabled != null &&
                      indoorSensorId.isNotEmpty)
                  ? () {
                      _updateInfo('IndoorSensorID', indoorSensorId);
                      setState(() {
                        newI = false;
                        isInButtonEnabled = false;
                      });
                    }
                  : null,
              child: Text(
                'حفظ التغييرات',
                style: TextStyle(
                  color: isInButtonEnabled ? Colors.white : Colors.grey,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 43, 138, 159),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                labelText: 'معرف المستشعر الخارجي',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                suffixIcon: outdoorSensorId.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.only(left: 8.0),
                        child: infoWidget(
                          context,
                          "تستطيع إيجاد المعرف على المستشعر في الأسفل",
                          'images/outdoorSensorID.jpeg',
                        ),
                      )
                    : null,
              ),
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: outdoorSensorId,
                  selection: TextSelection.fromPosition(
                    TextPosition(offset: outdoorSensorId.length),
                  ),
                ),
              ),
              onChanged: (newValue) {
                setState(() {
                  outdoorSensorId = newValue;
                  newO = true;

                  isOutButtonEnabled = newValue.isNotEmpty;
                });
              },
              enabled: outdoorSensorId
                  .isNotEmpty, // Set the enabled property based on the value of outdoorSensorId
            ),
            if (outdoorSensorId
                .isEmpty) // Display the message if outdoorSensorId is empty
              Text(
                ' لم تضف أي مستشعر بعد، تستطيع إضافة مستشعر جديد من صفحة خارجي',
                style: TextStyle(color: Color.fromARGB(255, 78, 111, 135)),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: (isOutButtonEnabled &&
                      isOutButtonEnabled != null &&
                      outdoorSensorId.isNotEmpty)
                  ? () {
                      _updateInfo('OutdoorSensorID', outdoorSensorId);
                      setState(() {
                        newO = false;
                        isOutButtonEnabled = false;
                      });
                    }
                  : null,
              child: Text(
                'حفظ التغييرات',
                style: TextStyle(
                  color: isOutButtonEnabled ? Colors.white : Colors.grey,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 43, 138, 159),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                        width: 400,
                        height: 200,
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
}
