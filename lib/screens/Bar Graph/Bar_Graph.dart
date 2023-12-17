import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Bar_data.dart';

class MyBarGraph {
  static List Summary = [];
  double max = 0.0;
  static int type = 0;
  List<double> hourlyAverages = [];
  static List<String> formattedKeys = [];
  Future<List<double>> calculateSummary(int selectedIndexDuration,
      int selectedIndexType, int selectedIndexMeasure) async {
    Map<int, String> indexMap;
    type = selectedIndexDuration;
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

    hourlyAverages = [];

    if (selectedIndexDuration == 0) {
      DateTime currentTime = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentTime);

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
      }

      Map<String, List<dynamic>> hourlyMap = {};

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        Map<String, dynamic> data = document.data();
        if (data[indexMap[selectedIndexMeasure]] != null) {
          // Parse the date string into a DateTime object
          String date = data['date'];
          String time = data['time'];
          DateTime documentDate = DateTime.parse('$date $time');
          num measure = data[indexMap[selectedIndexMeasure]];

          String hourKey =
              '${documentDate.year}-${documentDate.month}-${documentDate.day} ${documentDate.hour}';

          if (!hourlyMap.containsKey(hourKey)) {
            hourlyMap[hourKey] = [measure];
          } else {
            hourlyMap[hourKey]!.add(measure);
          }
        }
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

      //Calculate average for each hour
      sortedMap.forEach((hour, temperatures) {
        double averageTemperature =
            temperatures.reduce((a, b) => a + b) / temperatures.length;
        hourlyAverages.add(averageTemperature);
      });
    } else if ((selectedIndexDuration == 1) || (selectedIndexDuration == 2)) {
      DateTime lastDurationDate = DateTime.now();

      if (selectedIndexDuration == 1) {
        lastDurationDate = lastDurationDate.subtract(Duration(days: 6));
      } else if (selectedIndexDuration == 2) {
        lastDurationDate = lastDurationDate.subtract(Duration(days: 30));
      }
      String formattedDate1 = DateFormat('yyyy-MM-dd').format(lastDurationDate);

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
      }

      Map<String, List<dynamic>> weeklyMap = {};

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        Map<String, dynamic> data = document.data();
        if (data[indexMap[selectedIndexMeasure]] != null) {
          // Parse the date string into a DateTime object
          String date = data['date'];
          String time = data['time'];
          DateTime documentDate = DateTime.parse('$date $time');

          num measure = data[indexMap[selectedIndexMeasure]];

          String dateKey = DateFormat('yyyy-MM-dd').format(documentDate);

          if (!weeklyMap.containsKey(dateKey)) {
            weeklyMap[dateKey] = [measure];
          } else {
            weeklyMap[dateKey]!.add(measure);
          }
        }
      }
      DateTime dateKey = DateTime.parse(formattedDate1);
      if (selectedIndexDuration == 1) {
        for (int i = 0; i < 7; i++) {
          String formattedKey = DateFormat('yyyy-MM-dd').format(dateKey);

          if (!weeklyMap.containsKey(formattedKey)) {
            weeklyMap[formattedKey] = [0];
          }
          dateKey = dateKey.add(Duration(days: 1));
        }
      } else if (selectedIndexDuration == 2) {
        for (int i = 0; i < 30; i++) {
          String formattedKey = DateFormat('yyyy-MM-dd').format(dateKey);

          if (!weeklyMap.containsKey(formattedKey)) {
            weeklyMap[formattedKey] = [0];
          }
          dateKey = dateKey.add(Duration(days: 1));
        }
      }

      // Get the keys and sort them
      List<String> sortedKeys = weeklyMap.keys.toList()
        ..sort((a, b) {
          // Compare keys directly as DateTime objects
          DateTime dateA = DateTime.parse(a);
          DateTime dateB = DateTime.parse(b);

          return dateA.compareTo(dateB);
        });

      // Create a new map with sorted keys
      Map<String, dynamic> sortedMap = Map.fromIterable(sortedKeys,
          key: (key) => key, value: (key) => weeklyMap[key]);

      //Calculate average for each hour
      sortedMap.forEach((hour, temperatures) {
        double averageTemperature =
            temperatures.reduce((a, b) => a + b) / temperatures.length;
        hourlyAverages.add(averageTemperature);
      });
      print("111111 $sortedMap");
      print("222222 $hourlyAverages");
      // Access keys and format as dd:MM
      formattedKeys = sortedMap.keys.map((key) {
        DateTime dateTime = DateTime.parse(key);
        String formattedDate =
            "${dateTime.day.toString().padLeft(2, '0')}${DateFormat('MMM').format(dateTime)}";
        return formattedDate;
      }).toList();

      // Print formatted keys
      print('33333 $formattedKeys');
    }

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
    int maxValue = 0;
    if (type == 0) {
      if (measure == 0) {
        max = hourlyAverages
            .reduce((value, element) => value > element ? value : element);

        max = double.parse(max.toStringAsFixed(0));

        if (max == 0) {
          max = 40;
        }

        while (max.toInt() % 10 != 0) {
          print(max.toInt() % 10);
          max++;
        }
      }
      if (measure == 1) {
        max = hourlyAverages
            .reduce((value, element) => value > element ? value : element);
        max = double.parse(max.toStringAsFixed(0));
        if (max == 0) {
          max = 100;
        }
        while (max.toInt() % 20 != 0) {
          max++;
        }
      }
      if (measure == 2) {
        max = hourlyAverages
            .reduce((value, element) => value > element ? value : element);
        max = double.parse(max.toStringAsFixed(0));
        if (max == 0) {
          max = 2000;
        }
        while (max.toInt() % 500 != 0) {
          max++;
        }
      }
    }
    if (type == 1) {
      if (measure == 0) {
        // max = 70;
        max = hourlyAverages
            .reduce((value, element) => value > element ? value : element);
        max = double.parse(max.toStringAsFixed(0));
        if (max == 0) {
          max = 70;
        }
        while (max.toInt() % 10 != 0) {
          max++;
        }
      }
      if (measure == 1) {
        max = hourlyAverages
            .reduce((value, element) => value > element ? value : element);
        max = double.parse(max.toStringAsFixed(0));
        if (max == 0) {
          max = 100;
        }
        while (max.toInt() % 20 != 0) {
          max++;
        }
      }
      if (measure == 2) {
        max = hourlyAverages
            .reduce((value, element) => value > element ? value : element);
        max = double.parse(max.toStringAsFixed(0));
        if (max == 0) {
          max = 50000;
        }
        while (max.toInt() % 5000 != 0) {
          max++;
        }
      }
    }
    double getInterval(int measure) {
      if (measure == 0) {
        return 10;
      } else if (measure == 1) {
        return 20;
      } else if ((measure == 2) && (type == 0)) {
        return 500;
      }
      return 5000;
    }

    return SizedBox(
      height: 300,
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
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, meta) {
                  double interval;

                  // Use a conditional statement to determine the title
                  int intValue = value.toInt();
                  if (measure == 0) {
                    return Text(
                      '$intValue\u00B0',
                      style: TextStyle(
                          fontSize: 12, color: Color.fromARGB(255, 95, 94, 94)),
                    );
                  } else if (measure == 1) {
                    return Text('$intValue%', style: TextStyle(fontSize: 12));
                  } else if (measure == 2 && type == 1) {
                    // Check if the value is above 1000 and display as K
                    if (value > 1000) {
                      return Text('${(value / 1000).toInt()}K',
                          style: TextStyle(fontSize: 12));
                    }
                  }
                  // Return the Text widget with the determined title
                  return Text('$intValue', style: TextStyle(fontSize: 12));
                },
                interval: getInterval(measure),
              ),
            ),
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
                      color: Color.fromARGB(255, 116, 180, 196),
                      width: 5,
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
      color: Color.fromARGB(255, 95, 94, 94),
      fontSize: 12,
    );
    Widget text;
    text = const Text('', style: style);

    if (type == 0) {
      switch (value.toInt()) {
        case 0:
          text = const Text('12AM', style: style);
          break;
        case 1:
          text = const Text('', style: style);
          break;
        case 2:
          text = const Text('', style: style);
          break;
        case 3:
          text = const Text('', style: style);
          break;
        case 4:
          text = const Text('', style: style);
          break;
        case 5:
          text = const Text('', style: style);
          break;
        case 6:
          text = const Text('6AM', style: style);
          break;
        case 7:
          text = const Text('', style: style);
          break;
        case 8:
          text = const Text('', style: style);
          break;
        case 9:
          text = const Text('', style: style);
          break;
        case 10:
          text = const Text('', style: style);
          break;

        case 11:
          text = const Text('', style: style);
          break;
        case 12:
          text = const Text('12PM', style: style);
          break;
        case 13:
          text = const Text('', style: style);
          break;
        case 14:
          text = const Text('', style: style);
          break;
        case 15:
          text = const Text('', style: style);
          break;
        case 16:
          text = const Text('', style: style);
          break;
        case 17:
          text = const Text('', style: style);
          break;
        case 18:
          text = const Text('6PM', style: style);
          break;
        case 19:
          text = const Text('', style: style);
          break;
        case 20:
          text = const Text('', style: style);
          break;
        case 21:
          text = const Text('', style: style);
          break;
        case 22:
          text = const Text('', style: style);
          break;
        case 23:
          text = const Text('', style: style);
          break;
        default:
          text = const Text('', style: style);
          break;
      }
    }
    if (type == 1) {
      switch (value.toInt()) {
        case 0:
          text = Text(formattedKeys[0], style: style);
          break;
        case 1:
          text = Text(formattedKeys[1], style: style);
          break;
        case 2:
          text = Text(formattedKeys[2], style: style);
          break;
        case 3:
          text = Text(formattedKeys[3], style: style);
          break;
        case 4:
          text = Text(formattedKeys[4], style: style);
          break;
        case 5:
          text = Text(formattedKeys[5], style: style);
          break;
        case 6:
          text = Text(formattedKeys[6], style: style);
          break;
        default:
          text = const Text('', style: style);
          break;
      }
    }

    if (type == 2) {
      switch (value.toInt()) {
        case 0:
          text = Text(formattedKeys[0], style: style);
          break;
        case 1:
          text = Text('', style: style);
          break;
        case 2:
          text = Text('', style: style);
          break;
        case 3:
          text = Text('', style: style);
          break;
        case 4:
          text = Text('', style: style);
          break;
        case 5:
          text = Text(formattedKeys[5], style: style);
          break;
        case 6:
          text = Text('', style: style);
          break;
        case 7:
          text = Text('', style: style);
          break;
        case 8:
          text = Text('', style: style);
          break;
        case 9:
          text = Text('', style: style);
          break;
        case 10:
          text = Text(formattedKeys[10], style: style);
          break;
        case 11:
          text = Text('', style: style);
          break;
        case 12:
          text = Text('', style: style);
          break;
        case 13:
          text = Text('', style: style);
          break;
        case 14:
          text = Text('', style: style);
          break;
        case 15:
          text = Text(formattedKeys[15], style: style);
          break;
        case 16:
          text = Text('', style: style);
          break;
        case 17:
          text = Text('', style: style);
          break;
        case 18:
          text = Text('', style: style);
          break;
        case 19:
          text = Text('', style: style);
          break;
        case 20:
          text = Text(formattedKeys[20], style: style);
          break;
        case 21:
          text = Text('', style: style);
          break;
        case 22:
          text = Text('', style: style);
          break;
        case 23:
          text = Text('', style: style);
          break;
        case 24:
          text = Text('', style: style);
          break;
        case 25:
          text = Text(formattedKeys[25], style: style);
          break;
        case 25:
          text = Text('', style: style);
          break;
        case 27:
          text = Text('', style: style);
          break;
        case 28:
          text = Text('', style: style);
          break;
        case 29:
          text = Text(formattedKeys[29], style: style);

          break;

        default:
          text = Text('', style: style);
          break;
      }
    }

    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }
}
