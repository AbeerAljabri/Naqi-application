import 'dart:async';
import 'package:http/http.dart' as http;

class Sensor {
  Stream<String> getReadings() =>
      Stream.periodic(Duration(seconds: 3)).asyncMap((_) => getReading());

  Future<String> getReading() async {
    final url =
        'https://webhook.site/token/cca1fa82-399e-46f7-bf47-c365ecf222bf/request/latest/raw';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // print("ok");
      return response.body.toString();
    } else {
      print("Connection Error");
      throw Exception("faild");
    }
  }
}
