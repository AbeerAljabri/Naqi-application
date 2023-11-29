import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'Bar_data.dart';

class MyBarGraph {
  List Summary = []; // [sunAmount, monAmount, .., satAmount]
  double max = 0.0;
   /*List calculateDay (int co2 )
{



return summary
}*/
/*List calculateWeekly (int co2 )
{

  

return summary
}*/
  Widget showTempbar(List Summary, int type, int reading) {
    late BarData myBarData;

    if (type == 0) {
      myBarData = BarData(
        hour0: Summary[0],
        hour1: Summary[1],
        hour2: Summary[2],
        hour3: Summary[3],
        hour4: Summary[4],
        hour5: Summary[5],
        hour6: Summary[6],
        hour7: Summary[7],
        hour8: Summary[8],
        hour9: Summary[9],
        hour10: Summary[10],
        hour11: Summary[11],
      );
      myBarData.initializeBarData(type);
    }

    if (type == 1) {
      myBarData = BarData(
        sunAmount: Summary[0],
        monAmount: Summary[1],
        tueAmount: Summary[2],
        wedAmount: Summary[3],
        thurAmount: Summary[4],
        friAmount: Summary[5],
        satAmount: Summary[6],
      );
      myBarData.initializeBarData(type);
      // myBarData.initializeBarData();
    }
    if (type == 2) {
      myBarData = BarData(
        week1: Summary[0],
        week2: Summary[1],
        week3: Summary[2],
        week4: Summary[3],
      );

      myBarData.initializeBarData(type);
    }
    if (reading == 0) {
      max = 40;
    }
    if (reading == 1) {
      max = 100;
    }
    if (reading == 2) {
      max = 2000;
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
                      width: 20,
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
      fontSize: 14,
    );
    Widget text;

    //String getBottomTitles(double value, int type) {
    // if (type == 0) {
    switch (value.toInt()) {
      case 0:
        text = const Text('00', style: style);
        break;
      case 1:
        text = const Text('02', style: style);
        break;
      case 2:
        text = const Text('04', style: style);
        break;
      case 3:
        text = const Text('06', style: style);
        break;
      case 4:
        text = const Text('08', style: style);
        break;
      case 5:
        text = const Text('10', style: style);
        break;
      case 6:
        text = const Text('12', style: style);
        break;
      case 7:
        text = const Text('14', style: style);
        break;
      case 8:
        text = const Text('16', style: style);
        break;
      case 9:
        text = const Text('18', style: style);
        break;
      case 10:
        text = const Text('20', style: style);
        break;

      case 11:
        text = const Text('22', style: style);
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
