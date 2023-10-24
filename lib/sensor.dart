import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:naqi_app/firebase.dart';

class Sensor {
  FirebaseService firebaseService = FirebaseService();
  String indoorURL = '';
  String outdoorURL = '';
  static num pm = 0.0;
  Stream<String> getIndoorReadings() =>
      Stream.periodic(Duration(milliseconds: 500))
          .asyncMap((_) => getIndoorReading());

  Future<String> getIndoorReading() async {
    indoorURL = FirebaseService.indoorSensorURL;

    final response = await http.get(Uri.parse(indoorURL));
    if (response.statusCode == 200) {
      return response.body.toString();
    } else {
      print("Connection Error");
      throw Exception("faild");
    }
  }

  Stream<String> getOutdoorReadings() =>
      Stream.periodic(Duration(milliseconds: 500))
          .asyncMap((_) => getOutdoorReading());

  Future<String> getOutdoorReading() async {
    getDust();
    outdoorURL = FirebaseService.outdoorSensorURL;
    final response = await http.get(Uri.parse(outdoorURL));
    if (response.statusCode == 200) {
      return response.body.toString();
    } else {
      print("Connection Error");
      throw Exception("faild");
    }
  }

  void getDust() {
    Future<num> dust = firebaseService.getdust();
    dust.then((value) {
      pm = value;
      if (pm > 1) pm = pm.round();
    });
  }
}
