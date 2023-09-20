import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:naqi_app/firebase.dart';

class Sensor {
  FirebaseService firebaseService = FirebaseService();
  String url = '';

  Stream<String> getReadings() => Stream.periodic(Duration(milliseconds: 500))
      .asyncMap((_) => getReading());

  Future<String> getReading() async {
    url = FirebaseService.indoorSensorURL;

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body.toString();
    } else {
      print("Connection Error");
      throw Exception("faild");
    }
  }
}
