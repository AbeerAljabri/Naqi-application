import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naqi_app/firebase.dart';

import '../internetConnection.dart';

class healthStatusPage extends StatefulWidget {
  healthStatusPage({Key? key}) : super(key: key);

  @override
  _healthStatusPageState createState() => _healthStatusPageState();
}

class _healthStatusPageState extends State<healthStatusPage> {
  internetConnection connection = internetConnection();

  final GlobalKey widget1Key = GlobalKey();
  final GlobalKey widget2Key = GlobalKey();
  String text =
      FirebaseService.healthStatus == true ? 'نعم' : 'لا'; // for health status
  String text1 = FirebaseService.healthStatusLevel; // for health status level
  String menu1Value = FirebaseService.healthStatus == true ? 'نعم' : 'لا';
  String menu2Value = FirebaseService.healthStatusLevel;
  bool isButtonEnabled = false; // Add a boolean variable to track button state
  @override
  void initState() {
    super.initState();
    menu1Value = FirebaseService.healthStatus == true ? 'نعم' : 'لا';
    menu2Value = FirebaseService.healthStatusLevel;
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
          'الحالة الصحية',
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
          padding: const EdgeInsets.only(left: 12.0, right: 12, top: 60),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 7,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // Set the background color of the container
                            borderRadius: BorderRadius.circular(
                                20), // Set the border radius
                          ),
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  // Container( padding: const EdgeInsets.only(right: 12), child: icon),
                                  Container(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Center(
                                      child: Text(
                                        'هل تعاني من ظروف صحية تنفسية؟',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                key: widget1Key,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: Text(
                                      text,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          final RenderBox? renderBox1 =
                              widget1Key.currentContext?.findRenderObject()
                                  as RenderBox?;
                          if (renderBox1 != null) {
                            final Offset widget1Position =
                                renderBox1.localToGlobal(Offset.zero);

                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                widget1Position.dx, // Left
                                widget1Position.dy +
                                    renderBox1.size.height, // Top
                                widget1Position.dx +
                                    renderBox1.size.width, // Right
                                widget1Position.dy +
                                    renderBox1.size.height +
                                    80.0, // Bottom
                              ), // Adjust the position as needed
                              items: [
                                PopupMenuItem(
                                  child: Text('نعم'),
                                  value: 'نعم',
                                ),
                                PopupMenuItem(
                                  child: Text('لا'),
                                  value: 'لا',
                                ),
                              ],
                            ).then((value) {
                              if (value != null) {
                                setState(() {
                                  text = value;
                                  menu1Value = value;
                                  isButtonEnabled = true;
                                  if (menu1Value == 'لا') text1 = 'خفيف';
                                });
                              }
                            });
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Divider(
                          color: Colors.grey, // Specify the color of the line
                          height: 1.0, // Specify the height of the line
                          thickness: 0.50, // Specify the thickness of the line
                        ),
                      ),
                      Visibility(
                        visible: menu1Value == 'نعم',
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Set the background color of the container
                              borderRadius: BorderRadius.circular(
                                  20), // Set the border radius
                            ),
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: [
                                    // Container( padding: const EdgeInsets.only(right: 12), child: icon),
                                    Container(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Center(
                                        child: Text(
                                          'مستوى الحالة الصحية',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  key: widget2Key,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: Text(
                                        text1,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            final RenderBox? renderBox2 =
                                widget2Key.currentContext?.findRenderObject()
                                    as RenderBox?;
                            if (renderBox2 != null) {
                              final Offset widget2Position =
                                  renderBox2.localToGlobal(Offset.zero);

                              showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(
                                  widget2Position.dx, // Left
                                  widget2Position.dy +
                                      renderBox2.size.height, // Top
                                  widget2Position.dx +
                                      renderBox2.size.width, // Right
                                  widget2Position.dy +
                                      renderBox2.size.height +
                                      80.0, // Bottom
                                ),
                                items: [
                                  PopupMenuItem(
                                    child: Text('خفيف'),
                                    value: 'خفيف',
                                  ),
                                  PopupMenuItem(
                                    child: Text('متوسط'),
                                    value: 'متوسط',
                                  ),
                                  PopupMenuItem(
                                    child: Text('شديد'),
                                    value: 'شديد',
                                  ),
                                ],
                              ).then((value) {
                                if (value != null) {
                                  isButtonEnabled = true;
                                  setState(() {
                                    text1 = value;
                                    menu2Value = value;
                                  });
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: isButtonEnabled
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

                            // Continue with the save operation
                            FirebaseService.healthStatus =
                                menu1Value == 'نعم' ? true : false;
                            updateInfo(
                                'healthStatus', FirebaseService.healthStatus);
                            if (!FirebaseService.healthStatus)
                              menu2Value = 'خفيف';

                            FirebaseService.healthStatusLevel = menu2Value;

                            updateInfo('healthStatusLevel',
                                FirebaseService.healthStatusLevel);

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
                                        setState(() {
                                          isButtonEnabled = false;
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
                        color:
                            isButtonEnabled ? Colors.white : Colors.grey[700],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 43, 138, 159),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
