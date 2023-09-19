import 'package:firebase_database/firebase_database.dart';
import 'package:naqi_app/firebase.dart';
import 'package:naqi_app/fan.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:naqi_app/screens/indoor_screen.dart';
import 'package:naqi_app/screens/indoor_screen.dart';

class Controller {
  String status = '';
  String isSwitchOn = '';
  String atomatic = '';
  FirebaseService firebase = FirebaseService();
  Fan fan = Fan();
  // bool switchStatus = IndoorPage.getSwitchStatus();
  void checkAirQualityData(var co2) {
    // Get fan status and switch status from databse
    Future<String> fanStatus = firebase.getStatus();
    Future<String> fanSwitch = firebase.isSwitchOn();
    Future<String> isAutomatic = firebase.isAutomatic();

    fanStatus.then((value) {
      status = value;

      isAutomatic.then((value) {
        atomatic = value;
        // check CO2 and fan status
        if ((co2 > 1000) & (status == '0')) {
          fan.turnOn();
          fan.updateisAutomatic(1);
          fan.updateSwitch(1);

          sendNotification(
              "مستوى ثاني أكسيد الكربون مرتفع! سيتم تشغيل المروحة");
        } // check CO2 and fan status and switch status
        else if ((co2 <= 1000) & (atomatic == '1')) {
          fan.turnOff();
          fan.updateisAutomatic(0);
          fan.updateSwitch(0);
          sendNotification("مستوى ثاني أكسيد الكربون جيد! سيتم ايقاف المروحة");
        }
      });
    });
  }

  sendNotification(String text) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10, channelKey: "default_channel", title: "تنبيه!", body: text),
    );
  }
}
