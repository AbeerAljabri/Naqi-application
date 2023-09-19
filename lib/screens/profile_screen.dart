import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naqi_app/firebase.dart';
import 'package:naqi_app/screens/login_screen.dart';

import '../internetConnection.dart';

class profilePage extends StatefulWidget {
  profilePage({Key? key}) : super(key: key);

  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  String originalFirstName = FirebaseService.first_name ?? "";
  bool changesMade = false; // Add a boolean variable to track changes
  bool isButtonEnabled = false; // Add a boolean variable to track button state

 internetConnection connection = internetConnection();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' المعلومات الشخصية ',
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
                      Text(
                        'الاسم الأول',
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
                                originalFirstName, // Use the original value
                            onChanged: (newValue) {
                              setState(() {
                                originalFirstName =
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
                ),

               
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('البريد الإلكتروني',
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
                            FirebaseService.email ?? "",
                            style: TextStyle(
                              color: Colors
                                  .grey[600], // Set the color to dark grey
                            ),
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
                          originalFirstName != null &&
                          originalFirstName.isNotEmpty
                    )
                      ? () async {
                          // Check for internet connection
                          bool isConnected = await connection.checkInternetConnection();

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
                          if (originalFirstName != null &&
                              originalFirstName.isNotEmpty) {
                            FirebaseService.first_name = originalFirstName;
                            updateInfo('firstName', originalFirstName);
                          }

                          // After updating Firestore, show a success message
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
                        }
                      : null,
                  child: Text(
                    'حفظ التغييرات',
                    style: TextStyle(
                      color: (isButtonEnabled &&
                              originalFirstName != null &&
                              originalFirstName.isNotEmpty
                             )
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
