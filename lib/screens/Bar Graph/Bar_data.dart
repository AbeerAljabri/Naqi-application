import 'package:naqi_app/screens/Bar%20Graph/individual_bar.dart';

class BarData {
  final double hour0;
  final double hour1;
  final double hour2;
  final double hour3;
  final double hour4;
  final double hour5;
  final double hour6;
  final double hour7;
  final double hour8;
  final double hour9;
  final double hour10;
  final double hour11;
  final double hour12;
  final double hour13;
  final double hour14;
  final double hour15;
  final double hour16;
  final double hour17;
  final double hour18;
  final double hour19;
  final double hour20;
  final double hour21;
  final double hour22;
  final double hour23;
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thurAmount;
  final double friAmount;
  final double satAmount;
  final double week1;
  final double week2;
  final double week3;
  final double week4;

  BarData({
    this.hour0 = 0.0,
    this.hour1 = 0.0,
    this.hour2 = 0.0,
    this.hour3 = 0.0,
    this.hour4 = 0.0,
    this.hour5 = 0.0,
    this.hour6 = 0.0,
    this.hour7 = 0.0,
    this.hour8 = 0.0,
    this.hour9 = 0.0,
    this.hour10 = 0.0,
    this.hour11 = 0.0,
    this.hour12 = 0.0,
    this.hour13 = 0.0,
    this.hour14 = 0.0,
    this.hour15 = 0.0,
    this.hour16 = 0.0,
    this.hour17 = 0.0,
    this.hour18 = 0.0,
    this.hour19 = 0.0,
    this.hour20 = 0.0,
    this.hour21 = 0.0,
    this.hour22 = 0.0,
    this.hour23 = 0.0,
    this.sunAmount = 0.0,
    this.monAmount = 0.0,
    this.tueAmount = 0.0,
    this.wedAmount = 0.0,
    this.thurAmount = 0.0,
    this.friAmount = 0.0,
    this.satAmount = 0.0,
    this.week1 = 0.0,
    this.week2 = 0.0,
    this.week3 = 0.0,
    this.week4 = 0.0,
  });

  List<IndividualBar> barData = [];

// initialize bar data
  void initializeBarData(int type) {
    // if sttamet fot type
    //var type;
    if (type == 0) {
      barData = [
        IndividualBar(x: 0, y: hour0),
        IndividualBar(x: 1, y: hour1),
        IndividualBar(x: 2, y: hour2),
        IndividualBar(x: 3, y: hour3),
        IndividualBar(x: 4, y: hour4),
        IndividualBar(x: 5, y: hour5),
        IndividualBar(x: 6, y: hour6),
        IndividualBar(x: 7, y: hour7),
        IndividualBar(x: 8, y: hour8),
        IndividualBar(x: 9, y: hour9),
        IndividualBar(x: 10, y: hour10),
        IndividualBar(x: 11, y: hour11),
        IndividualBar(x: 12, y: hour12),
        IndividualBar(x: 13, y: hour13),
        IndividualBar(x: 14, y: hour14),
        IndividualBar(x: 15, y: hour15),
        IndividualBar(x: 16, y: hour16),
        IndividualBar(x: 17, y: hour17),
        IndividualBar(x: 18, y: hour18),
        IndividualBar(x: 19, y: hour19),
        IndividualBar(x: 20, y: hour20),
        IndividualBar(x: 21, y: hour21),
        IndividualBar(x: 22, y: hour22),
        IndividualBar(x: 23, y: hour23),
      ];
    }

    if (type == 1) {
      barData = [
// sun
        IndividualBar(x: 0, y: sunAmount),
// mon
        IndividualBar(x: 1, y: monAmount),
// tue
        IndividualBar(x: 2, y: tueAmount),
// wed
        IndividualBar(x: 3, y: wedAmount),
// thur
        IndividualBar(x: 4, y: thurAmount),
// fri
        IndividualBar(x: 5, y: friAmount),
// sat
        IndividualBar(x: 6, y: satAmount),
      ];
    }
    if (type == 2) {
      barData = [
        IndividualBar(x: 0, y: week1),
        IndividualBar(x: 1, y: week2),
        IndividualBar(x: 2, y: week3),
        IndividualBar(x: 3, y: week4),
      ];
    }
  }
}
