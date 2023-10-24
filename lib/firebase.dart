import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static var first_name;
  static var last_name;
  static var email;
  static var healthStatus;
  static var healthStatusLevel;
  static String switchStatus = '';
  static String automatic = '';
  static String indoorSensorID = '';
  static String outdoorSensorID = '';
  static String indoorSensorURL = '';
  static String outdoorSensorURL = '';

  static num dust = 0;
  //DatabaseReference databaseRef;
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyAGL08HmIE1Rdw8AXu9R3fo2WP2qJkQebE',
        appId: '1:737896249852:android:d517b291008da9cd35da79',
        messagingSenderId: '737896249852',
        projectId: 'fairbase-naqi-app',
        databaseURL: 'https://fairbase-naqi-app-default-rtdb.firebaseio.com',
      ),
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchUserInfo(
      String userId) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final userSnapshot = await userRef.get();
    return userSnapshot;
  }

  void getUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userInfo = await fetchUserInfo(userId);
      first_name = userInfo.data()!['firstName'];
      email = userInfo.data()!['userEmail'];
      healthStatus = userInfo.data()!['healthStatus'];
      healthStatusLevel = userInfo.data()!['healthStatusLevel'];
      if (userInfo.data()!.containsKey('IndoorSensorID')) {
        indoorSensorID = userInfo.data()!['IndoorSensorID'];
        getIndoorSensorURL(indoorSensorID);
      } else {
        indoorSensorID =
            ''; // Set a default value or handle the absence of the key accordingly
      }

      if (userInfo.data()!.containsKey('OutdoorSensorID')) {
        outdoorSensorID = userInfo.data()!['OutdoorSensorID'];
        getOudoorSensorURL(outdoorSensorID);
      } else {
        outdoorSensorID =
            ''; // Set a default value or handle the absence of the key accordingly
      }
    }
  }

  Future<String> getIndoorSensorID() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userInfo = await fetchUserInfo(userId);
      if (userInfo.data()!.containsKey('IndoorSensorID')) {
        indoorSensorID = userInfo.data()!['IndoorSensorID'];
      } else {
        indoorSensorID = '';
      }
    }

    return indoorSensorID;
  }

  Future<String> getIndoorSensorURL(String sensorID) async {
    try {
      final sensorDoc = await FirebaseFirestore.instance
          .collection('Sensor')
          .where('SensorID', isEqualTo: sensorID)
          .get();

      if (sensorDoc.docs.isNotEmpty) {
        final sensorDoc1 = sensorDoc.docs.first;
        indoorSensorURL = sensorDoc1.data()['URL'];

        return indoorSensorURL;
      } else {
        return ''; // No sensor document with the given sensorID found
      }
    } catch (e) {
      print('Error retrieving sensor URL: $e');
      return ''; // Handle any errors that occur during the Firestore operation
    }
  }

  Future<String> getOudoorSensorID() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userInfo = await fetchUserInfo(userId);
      if (userInfo.data()!.containsKey('OutdoorSensorID')) {
        outdoorSensorID = userInfo.data()!['OutdoorSensorID'];
      } else {
        outdoorSensorID = '';
      }
    }
    return outdoorSensorID;
  }

  Future<String> getOudoorSensorURL(String sensorID) async {
    try {
      final sensorDoc = await FirebaseFirestore.instance
          .collection('Sensor')
          .where('SensorID', isEqualTo: sensorID)
          .get();
      if (sensorDoc.docs.isNotEmpty) {
        // Assuming there could be multiple documents with the same sensorID, you may choose which one to return or handle them as needed.
        final sensorDoc1 = sensorDoc.docs.first;
        outdoorSensorURL = sensorDoc1.data()['URL'];
        return outdoorSensorURL;
      } else {
        return ''; // No sensor document with the given sensorID found
      }
    } catch (e) {
      print('Error retrieving sensor URL: $e');
      return ''; // Handle any errors that occur during the Firestore operation
    }
  }

  Future<String> getStatus() async {
    String status = '';
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('Fan/Status').get();
    if (snapshot.exists) {
      status = snapshot.value.toString();
    } else {
      print('No data available.');
    }
    return status;
  }

  Future<String> isSwitchOn() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('Fan/isSwitchOn').get();
    if (snapshot.exists) {
      switchStatus = snapshot.value.toString();
    } else {
      print('No data available.');
    }
    return switchStatus;
  }

  Future<String> isAutomatic() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('Fan/isAutomatic').get();
    if (snapshot.exists) {
      automatic = snapshot.value.toString();
    } else {
      print('No data available.');
    }
    return automatic;
  }

  Future<num> getdust() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('PM10').orderByKey().limitToLast(1).get();
    if (snapshot.exists) {
      final values = snapshot.value as Map<dynamic, dynamic>;
      if (values != null) {
        dust = values.values.first;
      }
    } else {
      print('No data available.');
    }

    return dust;
  }
}
