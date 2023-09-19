import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static var first_name;
  static var last_name;
  static var email;
  static var healthStatus = false;
  static var healthStatusLevel;
  static String switchStatus = '';
  static String automatic = '';
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
      last_name = userInfo.data()!['lastName'];
      email = userInfo.data()!['userEmail'];
      healthStatus = userInfo.data()!['healthStatus'];
      healthStatusLevel = userInfo.data()!['healthStatusLevel'];
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
}
