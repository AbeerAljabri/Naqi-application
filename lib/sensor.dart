import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:naqi_app/firebase.dart';
import 'dart:convert';
import 'package:naqi_app/outdoorAirQuality.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Sensor {
  FirebaseService firebaseService = FirebaseService();
  String indoorURL = '';
  String outdoorURL = '';
  static num dust = 0.0;
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
    outdoorURL = FirebaseService.outdoorSensorURL;
    final response = await http.get(Uri.parse(outdoorURL));
    if (response.statusCode == 200) {
      var time = getTime(response.body);
      dust = await getDust(time);

      if (dust > 1) dust = dust.round();
      return response.body.toString();
    } else {
      print("Connection Error");
      throw Exception("faild");
    }
  }

  DateTime getTime(dynamic response) {
    var time;
    // Parse the JSON response
    Map<String, dynamic> jsonResponse = json.decode(response);
    // Extract the 'received_at' value
    String receivedAt = jsonResponse['received_at'];
    time = DateTime.parse(receivedAt);
    return time;
  }

  Future<num> getDust(DateTime time) async {
    num? dust = 0.0;

    // Extract date and time components
    String dateString =
        "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}";
    String timeString =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

    print("Date: $dateString");
    print("Time: $timeString");

    final collection = FirebaseFirestore.instance.collection('dustTest');

    // Query the collection for documents that match the date and time
    final querySnapshot = await collection
        .where('date', isEqualTo: dateString)
        .where('time', isEqualTo: timeString)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data() as Map<String, dynamic>;

      // Access the data fields
      dust = data['dust'];
      if (dust != null) {
        return dust;
      }
    }
    // Return 0 if no matching entry is found
    return 0;
  }
}
