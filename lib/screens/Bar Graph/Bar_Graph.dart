import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Bar_data.dart';

class MyBarGraph {
  static List Summary = []; // [sunAmount, monAmount, .., satAmount]
  double max = 0.0;

  Future<List<double>> calculateSummary(int selectedIndexDuration,
      int selectedIndexType, int selectedIndexMeasure) async {
    Map<int, String> indexMap;

    if (selectedIndexType == 0) {
      indexMap = {
        0: 'temperature',
        1: 'humidity',
        2: 'co2',
        3: 'eui-24e124707d084307',
        4: 'IndoorAirQuality',
      };
    } else {
      indexMap = {
        0: 'temperature',
        1: 'humidity',
        2: 'dust',
        3: 'eui-24e124136d416846',
        4: 'OutdoorAirQuality',
      };
    }
    //print('11111111111111111111111111');

    //print('selectedIndexDuration: $selectedIndexDuration');
    // print('Current Date: $formattedDate');
    //DateTime lastDurationDate;
    List<double> hourlyAverages = [];
    List<double> dailyAverages = [];
    List<double> monthlyAverages = [];

    if (selectedIndexDuration == 0) {
      DateTime currentTime = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentTime);
    // String formattedDate = '2023-11-30';
      // Query temperature data for indoor air quality
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Sensor')
          .doc(indexMap[3])
          .collection(indexMap[4]!)
          .where('date', isEqualTo: formattedDate)
          .get();
      var i = 0;
      // Iterate through the documents and print their data
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        Map<String, dynamic> data = document.data();
        i = i + 1;
        // print('Document ID: ${document.id}');
        // print('Data: $data');
        //print('------------------------');
      }
      // print(i);

      Map<String, List<dynamic>> hourlyMap = {};

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        Map<String, dynamic> data = document.data();
        if (data[indexMap[selectedIndexMeasure]] != null) {
          // Parse the date string into a DateTime object
          String date = data['date'];
          String time = data['time'];
          DateTime documentDate = DateTime.parse('$date $time');

          //  print('Parsed DateTime: $documentDate');
          // DateTime documentDate = (data['date']).toDate();
          //  print('1 $documentDate');

          num measure = data[indexMap[selectedIndexMeasure]];
          //  print('2 $measure');
          String hourKey =
              '${documentDate.year}-${documentDate.month}-${documentDate.day} ${documentDate.hour}';
          // print('3 $hourKey');
          if (!hourlyMap.containsKey(hourKey)) {
            hourlyMap[hourKey] = [measure];
          } else {
            hourlyMap[hourKey]!.add(measure);
          }
          // print("4 $hourlyMap");
        }
        print('5 $hourlyMap');
      }

      for (int i = 0; i < 24; i++) {
        String hourKey = '$formattedDate $i';
        if (!hourlyMap.containsKey(hourKey)) hourlyMap[hourKey] = [0];
      }
      // Get the keys and sort them
      List<String> sortedKeys = hourlyMap.keys.toList()
        ..sort((a, b) {
          // Extract the hour part from the key (assuming it's in the format 'YYYY-MM-DD HH')
          int hourA = int.parse(a.split(' ')[1]);
          int hourB = int.parse(b.split(' ')[1]);

          // Compare based on the hour part
          return hourA.compareTo(hourB);
        });

      // Create a new map with sorted keys
      Map<String, dynamic> sortedMap = Map.fromIterable(sortedKeys,
          key: (key) => key, value: (key) => hourlyMap[key]);

      // Print the sorted map
      //print("7 $sortedKeys");
      // print("8 $sortedMap");
      //Calculate average for each hour
      sortedMap.forEach((hour, temperatures) {
        double averageTemperature =
            temperatures.reduce((a, b) => a + b) / temperatures.length;
        hourlyAverages.add(averageTemperature);
      });
      // print('6 $hourlyAverages');
    } 
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    else if( (selectedIndexDuration == 1 )||(selectedIndexDuration == 2 ) ){
     DateTime lastDurationDate = DateTime.now();
     //DateTime lastDurationDate = DateTime(2023, 11, 1);

      print("11 $lastDurationDate");
      if (selectedIndexDuration == 1 ){
      lastDurationDate = lastDurationDate.subtract(Duration(days: 6));}
      else if (selectedIndexDuration == 2 )
      {   lastDurationDate = lastDurationDate.subtract(Duration(days: 30));}
      String formattedDate1 = DateFormat('yyyy-MM-dd').format(lastDurationDate);
      print("10 $formattedDate1");

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Sensor')
          .doc(indexMap[3])
          .collection(indexMap[4]!)
          .where('date', isGreaterThanOrEqualTo: formattedDate1)
          .get();
      var i = 0;
      // Iterate through the documents and print their data
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        Map<String, dynamic> data = document.data();
        i = i + 1;
        print('Document ID: ${document.id}');
        print('Data: $data');
        print('------------------------');
      }
      // print(i);

      Map<String, List<dynamic>> weeklyMap = {};

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        Map<String, dynamic> data = document.data();
        if (data[indexMap[selectedIndexMeasure]] != null) {
          // Parse the date string into a DateTime object
          String date = data['date'];
          String time = data['time'];
          DateTime documentDate = DateTime.parse('$date $time');

          //  print('Parsed DateTime: $documentDate');
          // DateTime documentDate = (data['date']).toDate();
          //  print('1 $documentDate');

          num measure = data[indexMap[selectedIndexMeasure]];
          print('2 $measure');
          String dateKey = DateFormat('yyyy-MM-dd').format(documentDate);
          print('3 $dateKey');
          if (!weeklyMap.containsKey(dateKey)) {
            weeklyMap[dateKey] = [measure];
          } else {
            weeklyMap[dateKey]!.add(measure);
          }
          print("4 $weeklyMap");
        }
        print('5 $weeklyMap');
      }
      DateTime dateKey = DateTime.parse(formattedDate1);
      if(selectedIndexDuration == 1 ){
      for (int i = 0; i < 7; i++) {
        String formattedKey = DateFormat('yyyy-MM-dd').format(dateKey); 
              print('12 $formattedKey');
        if (!weeklyMap.containsKey(formattedKey)) {
          weeklyMap[formattedKey] = [0];
        }
        dateKey = dateKey.add(Duration(days: 1));
      }
      } else   if(selectedIndexDuration == 2){
      for (int i = 0; i < 30; i++) {
        String formattedKey = DateFormat('yyyy-MM-dd').format(dateKey); 
              print('12 $formattedKey');
        if (!weeklyMap.containsKey(formattedKey)) {
          weeklyMap[formattedKey] = [0];
        }
        dateKey = dateKey.add(Duration(days: 1));
      }
      }


     



// Now, weeklyMap contains entries for all dates within the range, and missing ones have values set to zero
      print('Modified Weekly Map: $weeklyMap');

      // Get the keys and sort them
     List<String> sortedKeys = weeklyMap.keys.toList()
  ..sort((a, b) {
    // Compare keys directly as DateTime objects
    DateTime dateA = DateTime.parse(a);
    DateTime dateB = DateTime.parse(b);

    return dateA.compareTo(dateB);
  });
print("14 $sortedKeys");

      // Create a new map with sorted keys
     Map<String, dynamic> sortedMap = Map.fromIterable(sortedKeys,
     key: (key) => key, value: (key) => weeklyMap[key]);

      // Print the sorted map
      print("7 $sortedKeys");
      print("8 $sortedMap");
      //Calculate average for each hour
    sortedMap.forEach((hour, temperatures) {
        double averageTemperature =
            temperatures.reduce((a, b) => a + b) / temperatures.length;
        hourlyAverages.add(averageTemperature);
      });

      // week duration
    } /*else if (selectedIndexDuration == 2) {
      lastDurationDate = currentTime.subtract(Duration(days: 30));
      // month duration
    }*/

    return hourlyAverages;
  }

  Widget showBar(List summary, int duration, int type, int measure) {
    late BarData myBarData;

    if (duration == 0) {
      myBarData = BarData(
        hour0: summary[0],
        hour1: summary[1],
        hour2: summary[2],
        hour3: summary[3],
        hour4: summary[4],
        hour5: summary[5],
        hour6: summary[6],
        hour7: summary[7],
        hour8: summary[8],
        hour9: summary[9],
        hour10: summary[10],
        hour11: summary[11],
        hour12: summary[12],
        hour13: summary[13],
        hour14: summary[14],
        hour15: summary[15],
        hour16: summary[16],
        hour17: summary[17],
        hour18: summary[18],
        hour19: summary[19],
        hour20: summary[20],
        hour21: summary[21],
        hour22: summary[22],
        hour23: summary[23],
      );
      myBarData.initializeBarData(duration);
    }

    if (duration == 1) {
      myBarData = BarData(
        sunAmount: summary[0],
        monAmount: summary[1],
        tueAmount: summary[2],
        wedAmount: summary[3],
        thurAmount: summary[4],
        friAmount: summary[5],
        satAmount: summary[6],
      );
      myBarData.initializeBarData(duration);
      // myBarData.initializeBarData();
    }
    if (duration == 2) {
      myBarData = BarData(
        day1: summary[0],
        day2: summary[1],
        day3: summary[2],
        day4: summary[3],
        day5: summary[4],
        day6: summary[5],
        day7: summary[6],
        day8: summary[7],
        day9: summary[8],
        day10: summary[9],
        day11: summary[10],
        day12: summary[11],
        day13: summary[12],
        day14: summary[13],
        day15: summary[14],
        day16: summary[15],
        day17: summary[16],
        day18: summary[17],
        day19: summary[18],
        day20: summary[19],
        day21: summary[20],
        day22: summary[21],
        day23: summary[22],
        day24: summary[23],
        day25: summary[24],
        day26: summary[25],
        day27: summary[26],
        day28: summary[27],
        day29: summary[28],
        day30: summary[29],
      );

      myBarData.initializeBarData(duration);
    }
    if (type == 0) {
      if (measure == 0) {
        max = 40;
      }
      if (measure == 1) {
        max = 100;
      }
      if (measure == 2) {
        max = 2000;
      }
    }
    if (type == 1) {
      if (measure == 0) {
        max = 70;
      }
      if (measure == 1) {
        max = 100;
      }
      if (measure == 2) {
        max = 50000;
      }
    }
// نضيف 3 اف ستيتمنت للنوع القراءة بحيث انه لو ضغط درجة الحرارة

    // myBarData.initializeBarData();

    return SizedBox(
      height: 310,
      width: 350,
      child: BarChart(
        BarChartData(
          maxY: max,
          minY: 0,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            )),
          ),
          barGroups: myBarData.barData
              .map(
                (data) => BarChartGroupData(
                  x: data.x,
                  barRods: [
                    BarChartRodData(
                      fromY: data.y,
                      color: Color.fromARGB(255, 43, 138, 159),
                      width: 10,
                      borderRadius: BorderRadius.circular(4),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        fromY: max,
                        color: Colors.grey[200],
                      ),
                      toY: 0,
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;

    //String getBottomTitles(double value, int type) {
    // if (type == 0) {
    switch (value.toInt()) {
      case 0:
        text = const Text('00', style: style);
        break;
      case 1:
        text = const Text('01', style: style);
        break;
      case 2:
        text = const Text('02', style: style);
        break;
      case 3:
        text = const Text('03', style: style);
        break;
      case 4:
        text = const Text('04', style: style);
        break;
      case 5:
        text = const Text('05', style: style);
        break;
      case 6:
        text = const Text('06', style: style);
        break;
      case 7:
        text = const Text('07', style: style);
        break;
      case 8:
        text = const Text('08', style: style);
        break;
      case 9:
        text = const Text('09', style: style);
        break;
      case 10:
        text = const Text('10', style: style);
        break;

      case 11:
        text = const Text('11', style: style);
        break;
      case 12:
        text = const Text('12', style: style);
        break;
      case 13:
        text = const Text('13', style: style);
        break;
      case 14:
        text = const Text('14', style: style);
        break;
      case 15:
        text = const Text('15', style: style);
        break;
      case 16:
        text = const Text('16', style: style);
        break;
      case 17:
        text = const Text('17', style: style);
        break;
      case 18:
        text = const Text('18', style: style);
        break;
      case 19:
        text = const Text('19', style: style);
        break;
      case 20:
        text = const Text('20', style: style);
        break;
      case 21:
        text = const Text('21', style: style);
        break;
      case 22:
        text = const Text('22', style: style);
        break;
      case 23:
        text = const Text('23', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(child: text, axisSide: meta.axisSide);
    // }
    /* if (type == 1) {
      switch (value.toInt()) {
          case 0:
        text = const Text('الاحد', style: style);
        break;
      case 1:
        text = const Text('الأثنين', style: style);
        break;
      case 2:
        text = const Text('الثلاثاء', style: style);
        break;
      case 3:
        text = const Text('الأربعاء', style: style);
        break;
      case 4:
        text = const Text('الخميس', style: style);
        break;
      case 5:
        text = const Text('الجمعة', style: style);
        break;
      case 6:
        text = const Text('السبت', style: style);
        break;
    
      }
       return SideTitleWidget(child: text, axisSide: meta.axisSide);
    }

    if (type == 2) {
      switch (value.toInt()) {
        case 0:
        text = const Text('الأسبوع الأول', style: style);
        break;
      case 1:
        text = const Text('الأسبوع الثاني', style: style);
        break;
      case 2:
        text = const Text('الأسبوع الثالث', style: style);
        break;
      case 3:
        text = const Text('الأسبوع الرابع', style: style);
        break;
      }
         return SideTitleWidget(child: text, axisSide: meta.axisSide);
    }
  }*/
    //  return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }

  /*class MyBarGraph extends StatelessWidget {
 final List weeklySummary; // [sunAmount, monAmount, .., satAmount]
  const MyBarGraph({
    Key? key,
    required this.weeklySummary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // initialize bar data
    BarData myBarData = BarData(
      sunAmount: 10.0,
      monAmount: 20.0,
      tueAmount: 30.0,
      wedAmount: 10.0,
      thurAmount: 10.0,
      friAmount: 40.0,
      satAmount: 40.0,
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              //getTitles: getBottomTitles,
            ),
          ),
        ),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    fromY: data.y,
                    color: Colors.grey[800],
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      fromY: 100,
                      color: Colors.grey[200],
                    ),
                    toY: double.infinity,
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  String getBottomTitles(double value, _) {
    switch (value.toInt()) {
      case 0:
        return 'S';
      case 1:
        return 'M';
      case 2:
        return 'T';
      case 3:
        return 'W';
      case 4:
        return 'T';
      case 5:
        return 'F';
      case 6:
        return 'S';
      default:
        return '';
    }
  }
}*/
}
