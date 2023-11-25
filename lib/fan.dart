import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naqi_app/firebase.dart';

class Fan {
  Future<void> sendDownlink(String payload) async {
    final String url =
        'https://eu1.cloud.thethings.network/api/v3/as/applications/naqi-indoor-controller/webhooks/controller-webhook/devices/controller/down/replace';

    // Define header content
    Map<String, String> headers = {
      'Authorization':
          'Bearer NNSXS.S5AHBXSHVE6LDQBI5SI7WTDZKZTVE7WLYAGY6BY.GGB427AY2WJVBMZHZVLXZ3GGSDAJDRAHTGVDZBYQZPJDTPHB457A',
      'Content-Type': 'application/json',
      'User-Agent': 'my-integration/my-integration-version',
    };

    //Define body content
    Map<String, dynamic> body = {
      'downlinks': [
        {
          'frm_payload': payload,
          'f_port': 2,
          'priority': 'NORMAL',
        }
      ],
    };
    //Send http request
    String jsonBody = json.encode(body);
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );
    print(response.body);
  }

  void setUpController() {
    sendDownlink('AQAAAQ==');
  }

  void turnOn() {
    sendDownlink('AwER');
    /*FirebaseDatabase.instance.reference().child("Fan").update({"Status": 1});
    FirebaseFirestore.instance
        .collection('Fan')
        .doc(
            'z0IChlO0HkJX0gJ6tZlF') // Replace 'your_document_id' with the actual document ID
        .update({"Status": '1'});*/

    try {
      FirebaseFirestore.instance
          .collection('Fan')
          .where('fanID', isEqualTo: FirebaseService.fanID)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          // Assuming there is only one document with the given fanID
          String documentID = querySnapshot.docs.first.id;

          // Update the document with the new value for 'isSwitchOn'
          FirebaseFirestore.instance.collection('Fan').doc(documentID).update({
            "Status": '1',
          }).then((value) {
            print('Status updated successfully!');
          }).catchError((error) {
            print('Error updating Status: $error');
          });
        } else {
          print('No document found with fanID: $FirebaseService.fanID');
        }
      }).catchError((error) {
        print('Error querying documents: $error');
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void turnOff() {
    sendDownlink('AwAA');
    /* FirebaseDatabase.instance.reference().child("Fan").update({"Status": 0});
    FirebaseFirestore.instance
        .collection('Fan')
        .doc(
            'z0IChlO0HkJX0gJ6tZlF') // Replace 'your_document_id' with the actual document ID
        .update({"Status": '0'});*/
    try {
      FirebaseFirestore.instance
          .collection('Fan')
          .where('fanID', isEqualTo: FirebaseService.fanID)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          // Assuming there is only one document with the given fanID
          String documentID = querySnapshot.docs.first.id;

          // Update the document with the new value for 'isSwitchOn'
          FirebaseFirestore.instance.collection('Fan').doc(documentID).update({
            "Status": '0',
          }).then((value) {
            print('Status updated successfully!');
          }).catchError((error) {
            print('Error updating Status: $error');
          });
        } else {
          print('No document found with fanID: $FirebaseService.fanID');
        }
      }).catchError((error) {
        print('Error querying documents: $error');
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateSwitch(String isSwitchOn) {
    FirebaseService.switchStatus = isSwitchOn;
    try {
      FirebaseFirestore.instance
          .collection('Fan')
          .where('fanID', isEqualTo: FirebaseService.fanID)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          // Assuming there is only one document with the given fanID
          String documentID = querySnapshot.docs.first.id;

          // Update the document with the new value for 'isSwitchOn'
          FirebaseFirestore.instance.collection('Fan').doc(documentID).update({
            'isSwitchOn': isSwitchOn,
          }).then((value) {
            print('Switch updated successfully!');
          }).catchError((error) {
            print('Error updating switch: $error');
          });
        } else {
          print('No document found with fanID: $FirebaseService.fanID');
        }
      }).catchError((error) {
        print('Error querying documents: $error');
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateisAutomatic(String isAutomatic) {
    try {
      FirebaseFirestore.instance
          .collection('Fan')
          .where('fanID', isEqualTo: FirebaseService.fanID)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          // Assuming there is only one document with the given fanID
          String documentID = querySnapshot.docs.first.id;

          // Update the document with the new value for 'isAutomatic'
          FirebaseFirestore.instance.collection('Fan').doc(documentID).update({
            'isAutomatic': isAutomatic,
          }).then((value) {
            print('isAutomatic updated successfully!');
          }).catchError((error) {
            print('Error updating isAutomatic: $error');
          });
        } else {
          print('No document found with fanID: $FirebaseService.fanID');
        }
      }).catchError((error) {
        print('Error querying documents: $error');
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  /*void updateisAutomatic2(int isAutomatic) {
    FirebaseDatabase.instance
        .reference()
        .child("Fan")
        .update({"isAutomatic": isAutomatic});
  }*/
}
