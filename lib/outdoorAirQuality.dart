import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:naqi_app/firebase.dart';
import 'package:naqi_app/sensor.dart';

class OutdoorAirQuality {
  static bool notificationSent = false;
  bool flag = true;
  var temp = 0;
  var hum = 0;
  var co2 = 0;
  num pm = 0.0;
  var time = DateTime(2000);
  FirebaseService firebase = FirebaseService();

  dynamic readData(dynamic data) {
    if (data.containsKey('uplink_message')) {
      var paylaod = (data as Map)['uplink_message'];
      if (paylaod.containsKey('decoded_payload')) {
        var paylaod1 = (paylaod as Map)['decoded_payload'];
        if (paylaod1.containsKey('temperature_1')) {
          temp = (data as Map)['uplink_message']['decoded_payload']
                  ['temperature_1']
              .round();
          hum = (data as Map)['uplink_message']['decoded_payload']['humidity_2']
              .round();
        }
      }
    }
    time = DateTime.parse((data as Map)['received_at']);
    pm = Sensor.pm;
    List<dynamic> readings = [temp, hum, pm, time];
    return readings;
  }

  Widget checkTime(var time, context) {
    DateTime currDt = DateTime.now();
    var diffDt = currDt.difference(time);
    var Min = diffDt.inMinutes;
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(time);
    if (Min >= 2 && flag) {
      flag = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBar(
          context,
          'تعذر الوصول للمستشعر !',
          duration: Duration(seconds: 5),
          actionLabel: 'حسنًا',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        );
      });
    }
    if (Min >= 2) {
      return Column(
        children: [
          SizedBox(height: 14),
          Text(
            'آخر تحديث للبيانات:',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
          Text(
            '$formattedDate',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ],
      );
    } else {
      return Text(
        '',
      );
    }
  }

  void showSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
    String actionLabel = 'حسنًا',
    VoidCallback? onPressed,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
        action: onPressed != null
            ? SnackBarAction(
                label: actionLabel,
                onPressed: onPressed,
              )
            : null,
      ),
    );
  }

  Widget viewOutdoorAirQuality(List<dynamic> readings, context) {
    List<String> levels = calculateLevel(readings);
    Map<String, Color> airQuality_color = calculateAirQuality(levels);
    String airQuality = airQuality_color.keys.first;
    Color color = airQuality_color.values.first;
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "مستوى جودة الهواء: ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color,
                ),
                padding:
                    EdgeInsets.only(top: 6, bottom: 6, left: 20, right: 20),
                child: Text(
                  airQuality,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _cardMenu(
                  context: context,
                  title: 'درجة الحرارة',
                  reading: readings[0].toString() + '\u00B0',
                  level: levels[0],
                  percent: calculatePercentege(readings)[0],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _cardMenu(
                  context: context,
                  title: 'مستوى الرطوبة',
                  reading: readings[1].toString() + '%',
                  level: levels[1],
                  percent: calculatePercentege(readings)[1],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _cardMenu(
                  context: context,
                  title: 'ثاني أكسيد الكربون',
                  reading: readings[2].toString(),
                  level: levels[2],
                  percent: calculatePercentege(readings)[2],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<double> calculatePercentege(List<dynamic> readings) {
    List<double> percentages = [];
    // temp percentage
    percentages.add(readings[0] / 40);

    // humidity percentage
    percentages.add(readings[1] / 100);

    // co2 percantsge
    percentages.add(readings[2] / 2000);

    return percentages;
  }

  List<String> calculateLevel(List<dynamic> readings) {
    List<String> levels = [];
    // temprature level
    if (readings[0] < 10) {
      levels.add("بارد");
    } else if ((readings[0] >= 10) & (readings[0] < 28)) {
      levels.add("معتدل");
    } else if (readings[0] >= 28) {
      levels.add("حار");
    }
    // humidity level
    if (readings[1] < 30) {
      levels.add("منخفض");
    } else if ((readings[1] >= 30) & (readings[1] <= 60)) {
      levels.add("متوسط");
    } else if (readings[1] > 60) {
      levels.add("عالي");
    }
    // co2 level
    if (readings[2] <= 1000) {
      levels.add("ممتاز");
    } else if ((readings[2] > 1000) & (readings[2] < 1500)) {
      levels.add("ملوث");
    } else if (readings[2] >= 1500) {
      levels.add("ملوث جدا");
    }

    return levels;
  }

  Map<String, Color> calculateAirQuality(List<String> levels) {
    String airQuality = 'ممتاز';
    for (String level in levels) {
      if (level == "ملوث جدا") {
        airQuality = level;
        return {airQuality: Colors.red};
      }
      if (level == "ملوث") {
        airQuality = level;
        return {airQuality: Colors.orange};
      }
    }
    return {airQuality: Colors.green};
  }

  Widget _cardMenu({
    required BuildContext context,
    required String title,
    required String reading,
    required String level,
    required double percent,
    Color color = Colors.white,
    Color fontColor = const Color.fromARGB(255, 107, 107, 107),
  }) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 23,
          ),
          width: 312,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 7,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (title == 'درجة الحرارة')
                Padding(
                  padding: EdgeInsets.only(right: 20, left: 0),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 240, 242, 243),
                    ),
                    child: CircleAvatar(
                      child: Icon(
                        Icons.thermostat,
                        color: Color(0xff45A1B6),
                        size: 25,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              if (title == 'مستوى الرطوبة')
                Padding(
                  padding: EdgeInsets.only(right: 20, left: 0),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 240, 242, 243),
                    ),
                    child: CircleAvatar(
                      child: Icon(
                        Icons.water_drop,
                        color: Color(0xff45A1B6),
                        size: 25,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              if (title == 'ثاني أكسيد الكربون')
                Padding(
                  padding: EdgeInsets.only(right: 20, left: 0),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 240, 242, 243),
                    ),
                    child: CircleAvatar(
                      child: Icon(
                        Icons.cloud,
                        color: Color(0xff45A1B6),
                        size: 25,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title == 'درجة الحرارة')
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      if (title == 'مستوى الرطوبة')
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      if (title == 'ثاني أكسيد الكربون')
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              level,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: fontColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CircularPercentIndicator(
                  animation: true,
                  animationDuration: 1000,
                  circularStrokeCap: CircularStrokeCap.round,
                  radius: 65,
                  lineWidth: 5,
                  percent: percent,
                  progressColor: const Color(0xff45A1B6),
                  center: Text(
                    reading.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (title == 'درجة الحرارة')
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: infoWidget(context,
                ' - يعتبر مستوى درجة الحرارة بارد إذا كان أقل من ١٠  \n - يعتبر مستوى درجة الحرارة معتدل إذا كان أعلى من أو يساوي ١٠ وأقل من ٢٨ \n  - يعتبر مستوى درجة الحرارة حار إذا كان أعلى من أو يساوي ٢٨'),
          ),
        if (title == 'مستوى الرطوبة')
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: infoWidget(context,
                ' - يعتبر مستوى الرطوبة منخفض إذا كان أقل من ٣٠  \n - يعتبر مستوى الرطوبة متوسط إذا كان أعلى من أو يساوي ٣٠ وأقل من أو يساوي ٦٠  \n  - يعتبر مستوى الرطوبة عالي إذا كان أعلى من ٦٠'),
          ),
        if (title == 'ثاني أكسيد الكربون')
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: infoWidget(context,
                'يمكن أن تؤثر المستويات العالية من ثاني أكسيد الكربون في الهواء الداخلي سلبًا على جودة الهواء وقد تضر بصحة الإنسان. \n تشمل الأعراض الشائعة المرتبطة بارتفاع مستويات ثاني أكسيد الكربون الصداع والتعب والغثيان والإغماء.  \n - يعتبر مستوى ثاني أكسيد الكربون ممتاز إذا كان اقل من أو يساي ١٠٠٠  \n - يعتبر مستوى ثاني أكسيد الكربون ملوث إذا كان أعلى من ١٠٠٠ وأقل من ١٥٠٠ \n  - يعتبر مستوى ثاني أكسيد الكربون ملوث جدًا إذا كان أعلى من أو يساوي ١٥٠٠'),
          ),
      ],
    );
  }

  Widget infoWidget(BuildContext context, String text) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'حسناً',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 43, 138, 159),
                  ),
                )
              ],
            ),
          ),
        );
      },
      icon: Icon(
        Icons.info_outline,
        size: 14,
        color: Color.fromARGB(255, 107, 107, 107),
      ),
    );
  }
}
