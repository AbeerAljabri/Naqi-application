import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naqi_app/auth.dart';

class SettingsPage extends StatelessWidget {
  Widget _arrow() {
    return Icon(
      Icons.arrow_forward_ios,
      size: 16.0,
      color: Colors.grey,
    );
  }

  Widget _icon(String name) {
    final Map<String, IconData> iconDataMap = {
      'personal_information': Icons.person,
      'health_Status': Icons.health_and_safety,
      'devices': Icons.sensors,
      'logOut': Icons.logout,
    };
    final IconData? iconData = iconDataMap[name];

    if (iconData != null) {
      return Icon(
        iconData,
        size: 20.0,
        color: Colors.grey,
      );
    } else {
      // Handle the case where the provided icon name is not found
      return Icon(
        Icons.error_outline, // You can change this to a different error icon
        size: 20.0,
        color: Colors.grey,
      );
    }
  }

  void onTapGesture(BuildContext context, String navifation) {
    // Navigate to the 'profilePage' when tapped
    Navigator.pushNamed(context, navifation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, top: 60),
        child: Container(
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
                      ItemCard(
                        title: 'المعلومات الشخصية',
                        color: Colors.white,
                        arrowWidget: _arrow(),
                        nextPage: 'profilePage',
                        icon: _icon('personal_information'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Divider(
                          color: Colors.grey, // Specify the color of the line
                          height: 1.0, // Specify the height of the line
                          thickness: 0.50, // Specify the thickness of the line
                        ),
                      ),
                      ItemCard(
                        title: 'الحالة الصحية',
                        color: Colors.white,
                        arrowWidget: _arrow(),
                        nextPage: 'healthStatusScreen',
                        icon: _icon('health_Status'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Divider(
                          color: Colors.grey, // Specify the color of the line
                          height: 1.0, // Specify the height of the line
                          thickness: 0.50, // Specify the thickness of the line
                        ),
                      ),
                      ItemCard(
                        title: 'الأجهزة',
                        color: Colors.white,
                        arrowWidget: _arrow(),
                        nextPage: 'devicesScreen',
                        icon: _icon('devices'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Divider(
                          color: Colors.grey, // Specify the color of the line
                          height: 1.0, // Specify the height of the line
                          thickness: 0.5, // Specify the thickness of the line
                        ),
                      ),
                      ItemCard(
                        title: 'تسجيل الخروج',
                        color: Colors.white,
                        textColor: Colors.red,
                        icon: _icon('logOut'),
                        nextPage: 'logOut',
                      ),
                    ],
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

class ItemCard extends StatelessWidget {
  ItemCard({
    this.title = '',
    this.color = Colors.white,
    this.arrowWidget = const Text(''),
    this.nextPage = '',
    this.textColor = Colors.black,
    this.icon = const Icon(
      Icons.settings,
    ),
  });
  Color color;
  Color textColor;
  String title;
  Widget arrowWidget;
  String nextPage;
  Widget icon;

  @override
  Widget build(BuildContext context) {
    void onTapGesture(BuildContext context, String navigation) {
      if (navigation == 'logOut') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('رسالة تأكيد'),
                  content: Text('هل تريد بالفعل تسجيل الخروج؟'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'لا',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        // Pop all routes from the navigation stack
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);

                        // Push the login page route
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Auth(),
                        ));
                      },
                      child: Text(
                        'نعم',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ));
      } else
        // Navigate to the navigation page when tapped
        Navigator.pushNamed(context, navigation);
    }

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Set the background color of the container
          borderRadius: BorderRadius.circular(20), // Set the border radius
        ),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.only(right: 12), child: icon),
                Container(
                  padding: const EdgeInsets.only(right: 12),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 12),
                  child: arrowWidget,
                ),
              ],
            )
          ],
        ),
      ),
      onTap: () {
        onTapGesture(context, nextPage);
      },
    );
  }
}
