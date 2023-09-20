import 'package:naqi_app/sensor.dart';
import 'dart:convert';
import 'package:naqi_app/indoorAirQuality.dart';
import 'package:flutter/material.dart';
import 'package:naqi_app/fan.dart';
import 'package:naqi_app/controller.dart';
import 'package:naqi_app/firebase.dart';

class IndoorPage extends StatefulWidget {
  IndoorPage({Key? key}) : super(key: key);

  @override
  _IndoorPageState createState() => _IndoorPageState();
}

class _IndoorPageState extends State<IndoorPage>
    with AutomaticKeepAliveClientMixin {
  Controller controller = Controller();

  @override
  void initState() {
    super.initState();
    //Listen to the stream
    sensor.getReadings().listen((data) {
      // This callback function is called every time new data is received from the stream
      var jsonData = jsonDecode(data);
      List<dynamic> reading = sensorReadings.readData(jsonData);
      var co2 = reading[2];
      controller.checkAirQualityData(co2);
    });
    Future<String> fanStatus = firebase.getStatus();
    fanStatus.then((value) {
      status = value;
    });

    Future<String> automatic = firebase.isAutomatic();
    automatic.then((value) {
      isAutomatic = value;
    });

    Future<String> fanSwitch = firebase.isSwitchOn();
    fanSwitch.then((value) {
      setState(() {
        switchOn = value;
        isSwitchOn = switchOn == '1' ? true : false;
      });
    });

    Future<String> indoorSensorID = firebase.getIndoorSensorID();
    indoorSensorID.then((value) {
      setState(() {
        indoorSensorID1 = value;
        FirebaseService.indoorSensorID = indoorSensorID1;
      });
      Future<String> indoorSensorURL =
          firebase.getIndoorSensorURL(indoorSensorID1);
      indoorSensorURL.then((value) {
        setState(() {
          indoorSensorUrl = value;
          FirebaseService.indoorSensorURL = indoorSensorUrl;
        });
      });
    });

    Future<String> outdoorSensorID = firebase.getOudoorSensorID();
    outdoorSensorID.then((value) {
      setState(() {
        outdoorSensorID1 = value;
        FirebaseService.outdoorSensorID = outdoorSensorID1;
      });
      Future<String> outdoorSensorURL =
          firebase.getOudoorSensorURL(outdoorSensorID1);
      outdoorSensorURL.then((value) {
        setState(() {
          outdoorSensorUrl = value;
          FirebaseService.outdoorSensorURL = outdoorSensorUrl;
        });
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
  Sensor sensor = Sensor();
  Fan fan = Fan();
  IndoorAirQuality sensorReadings = IndoorAirQuality();
  FirebaseService firebase = FirebaseService();
  String switchOn = '';

  bool isSwitchOn = false;

  String isAutomatic = '';
  String status = '';
  String indoorSensorID1 = '';
  String indoorSensorUrl = '';
  String outdoorSensorID1 = '';
  String outdoorSensorUrl = '';

  Widget build(BuildContext context) {
    //print(isSwitchOn);
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 0, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [],
              ),
              Expanded(
                child: Container(
                  height: 100.0,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 26),
                      StreamBuilder<String>(
                        stream: sensor.getReadings(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            print("no data");
                            return Container(
                              height: 100,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          strokeWidth: 3.0,
                                        ),
                                        SizedBox(height: 16),
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
                                  ),
                                ],
                              ),
                            );
                          } else {
                            var data = jsonDecode(snapshot.data.toString());
                            List<dynamic> readings =
                                sensorReadings.readData(data);
                            List<String> levels =
                                sensorReadings.calculateLevel(readings);

                            return Column(children: [
                              Row(
                                children: [
                                  sensorReadings.checkTime(readings[3]),
                                ],
                              ),
                              Row(
                                children: [
                                  sensorReadings.viewIndoorAirQuality(
                                      readings, context),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [controlFanWidget()]),
                            ]);
                          }
                        },
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

  Widget controlFanWidget() {
    Future<String> fanStatus = firebase.getStatus();
    fanStatus.then((value) {
      status = value;
    });

    /* Future<String> automatic = firebase.isAutomatic();
    automatic.then((value) {
      isAutomatic = value;
    });

    Future<String> fanSwitch = firebase.isSwitchOn();
    fanSwitch.then((value) {
      setState(() {
        switchOn = value;
        isSwitchOn = switchOn == '1' ? true : false;
      });
    });*/
    isSwitchOn = FirebaseService.switchStatus == '1' ? true : false;
    isAutomatic = FirebaseService.automatic;
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 2),
      child: Container(
        width: 310, // Adjust the width as needed
        height: 100, // Adjust the height as needed
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 251, 251, 251),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 8,
              offset: Offset(0, 5),
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 240, 242, 243),
                ),
                child: CircleAvatar(
                  child: Image.asset(
                    'images/fan.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(
                          'المروحة',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        if ((isSwitchOn == false) && (isAutomatic == '0'))
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 70),
                              child: Text(
                                'قيد الإيقاف',
                              ),
                            ),
                          ),
                        if ((isSwitchOn == true) || (isAutomatic == '1'))
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 70),
                              child: Text(
                                'قيد التشغيل',
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Switch(
                activeColor: isAutomatic == '0'
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : Colors.blueGrey.shade50,
                activeTrackColor: isAutomatic == '0'
                    ? const Color(0xff45A1B6)
                    : Colors.grey.shade200,
                inactiveThumbColor: isAutomatic == '0'
                    ? Colors.blueGrey.shade600
                    : Colors.blueGrey.shade50,
                inactiveTrackColor: isAutomatic == '0'
                    ? Colors.grey.shade400
                    : Colors.grey.shade200,
                splashRadius: 50.0,
                value: isSwitchOn,
                onChanged: isAutomatic == '0'
                    ? (value) {
                        setState(() {
                          if (value) {
                            fan.turnOn();
                            fan.updateSwitch(1);
                          } else {
                            fan.turnOff();
                            fan.updateSwitch(0);
                          }
                          isSwitchOn = value;
                          FirebaseService.switchStatus = isSwitchOn ? '1' : '0';
                        });
                      }
                    : null, // Set onChanged to null when the condition is not met
              ),
            ),
          ],
        ),
      ),
    );
  }
}
