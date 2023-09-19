import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

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
    FirebaseDatabase.instance.reference().child("Fan").update({"Status": 1});
  }

  void turnOff() {
    sendDownlink('AwAA');
    FirebaseDatabase.instance.reference().child("Fan").update({"Status": 0});
  }

  void updateSwitch(int isSwitchOn) {
    FirebaseDatabase.instance
        .reference()
        .child("Fan")
        .update({"isSwitchOn": isSwitchOn});
  }

  void updateisAutomatic(int isAutomatic) {
    FirebaseDatabase.instance
        .reference()
        .child("Fan")
        .update({"isAutomatic": isAutomatic});
  }
}
