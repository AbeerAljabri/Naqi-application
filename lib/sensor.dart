import 'dart:async';
import 'package:flutter/foundation.dart';
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
    print(outdoorURL);
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

    // Add three hours to the provided time
    time = time.add(Duration(hours: 3));
    return time;
  }

  Future<num> getDust(DateTime time) async {
    num? dust = null;

    // Extract date and time components of the future time
    String dateString =
        "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}";
    String timeString =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

    String secondTime =
        "${(time.minute > 0 ? time.hour.toString().padLeft(2, '0') : time.hour - 1)}:${(time.minute > 0 ? time.minute - 1 : 59).toString().padLeft(2, '0')}";

    final collection = FirebaseFirestore.instance.collection('Sensor');

    final documentId = 'eui-24e124136d416846';

// Query the subcollection 'OutdoorAirQuality' for documents that match the date and time
    final querySnapshot = await collection
        .doc(documentId)
        .collection('OutdoorAirQuality')
        .where('date', isEqualTo: dateString)
        .where('time', isEqualTo: timeString)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        dust = data['dust'];

        if (dust != null) {
          return dust;
        }
      }
    }
    if (dust == null) {
      // No documents with the exact time, so query for documents one minute before
      final querySnapshot1 = await collection
          .doc(documentId)
          .collection('OutdoorAirQuality')
          .where('date', isEqualTo: dateString)
          .where('time', isEqualTo: secondTime)
          .get();
      if (querySnapshot1.docs.isNotEmpty) {
        for (var doc in querySnapshot1.docs) {
          final data = doc.data() as Map<String, dynamic>;
          dust = data['dust'];

          if (dust != null) {
            return dust;
          }
        }
      }
    }
    // Return 0 if no matching entry is found
    return 0;
  }
}
