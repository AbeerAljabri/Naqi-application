import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naqi_app/firebase.dart';
import 'package:naqi_app/screens/login_screen.dart';


class profilePage extends StatefulWidget {
  profilePage({Key? key}) : super(key: key);
  
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  String originalFirstName = FirebaseService.first_name ?? "";
  String originalLastName = FirebaseService.last_name ?? "";
  bool changesMade = false; // Add a boolean variable to track changes
  bool isButtonEnabled = false; // Add a boolean variable to track button state

  @override
  void initState() {
    super.initState();
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
                      Text(
                        'الاسم الأخير',
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
                                originalLastName, // Use the original value
                            onChanged: (newValue) {
                              setState(() {
                                originalLastName =
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
                  onPressed: isButtonEnabled
                      ? () {
                          if (originalFirstName != null &&
                              originalFirstName.isNotEmpty) {
                            FirebaseService.first_name = originalFirstName;
                            updateInfo('firstName', originalFirstName);
                          }

                          if (originalLastName != null &&
                              originalLastName.isNotEmpty) {
                            FirebaseService.last_name = originalLastName;
                            updateInfo('lastName', originalLastName);
                          }

                          // After updating Firestore, show a success message
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              isButtonEnabled = false;
                              FocusScope.of(context)
                                  .unfocus(); // Hide the keyboard
                              return AlertDialog(
                                title: Text('تم الحفظ بنجاح'),
                                content: Text('تم حفظ التغييرات بنجاح.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      isButtonEnabled = true;
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
                      color: isButtonEnabled ? Colors.white : Colors.grey[700],
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
