import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'Bar Graph/Bar_Graph.dart';
import 'home_screen.dart';
class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  MyBarGraph graph = MyBarGraph();
   HomeSceen home = HomeSceen(index:1);
  int selectedIndexType = 0;
  int selectedIndexDuration = 0;
  int selectedIndexMeasure = 0;
  List b = [];
 //List b = [1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,2.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0];
 @override
  void initState() {
//b =graph.Summary1(0, 0, 0);
b = MyBarGraph.Summary;
 print(b);
    super.initState();
   
  }
  

  @override
  Widget build(BuildContext context) {

 
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ToggleSwitch(
                minWidth: 150.0,
                minHeight: 50.0,
                initialLabelIndex: selectedIndexDuration,
                activeBgColor: [Color.fromARGB(255, 43, 138, 159)],
                activeFgColor: Colors.white,
                inactiveBgColor: const Color.fromARGB(255, 239, 235, 235),
                inactiveFgColor: Colors.grey[900],
                totalSwitches: 3,
                labels: ['يومي', 'اسبوعي', 'شهري'],
                onToggle: (index) {
                  setState(() {
                    selectedIndexDuration = index!;
                    print('duration $selectedIndexDuration');
                  });
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
              //  child: Text(
             //     'duration $selectedIndexDuration type $selectedIndexType measure $selectedIndexMeasure'),
             //   graph.calculateSummary(selectedIndexDuration , selectedIndexType , selectedIndexMeasure);
             
                child: graph.showBar(
                   b,
                    selectedIndexDuration,
                    selectedIndexType,
                    selectedIndexMeasure)
                   
                    ),
   
            SizedBox(height: 16),

            if (selectedIndexDuration == 0) ...[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ToggleSwitch(
                  minWidth: 200.0,
                  minHeight: 50.0,
                  initialLabelIndex: selectedIndexType,
                  activeBgColor: [Color.fromARGB(255, 43, 138, 159)],
                  activeFgColor: Colors.white,
                  inactiveBgColor: const Color.fromARGB(255, 239, 235, 235),
                  inactiveFgColor: Colors.grey[900],
                  totalSwitches: 2,
                  labels: ['داخلي', 'خارجي'],
                  onToggle: (index) {
                    setState(() {
                      selectedIndexType = index!;
                      print('type $selectedIndexType');
                    });
                  },
                ),
              ),
              SizedBox(height: 15),
              if (selectedIndexType == 0) ...[
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 0;
                          print('duration $selectedIndexMeasure');
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 0
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'درجة الحرارة',
                        style: TextStyle(
                          color: selectedIndexMeasure == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 1;
                        });
                        //////here
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 1
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الرطوبة',
                        style: TextStyle(
                          color: selectedIndexMeasure == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 2
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'ثاني اكسيد الكربون',
                        style: TextStyle(
                          color: selectedIndexMeasure == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (selectedIndexType == 1) ...[
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 0
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'درجة الحرارة',
                        style: TextStyle(
                          color: selectedIndexMeasure == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 1
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الرطوبة',
                        style: TextStyle(
                          color: selectedIndexMeasure == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 2
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الغبار',
                        style: TextStyle(
                          color: selectedIndexMeasure == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],

            // week
            if (selectedIndexDuration == 1) ...[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ToggleSwitch(
                  minWidth: 200.0,
                  minHeight: 50.0,
                  initialLabelIndex: selectedIndexType,
                  activeBgColor: [Color.fromARGB(255, 43, 138, 159)],
                  activeFgColor: Colors.white,
                  inactiveBgColor: const Color.fromARGB(255, 239, 235, 235),
                  inactiveFgColor: Colors.grey[900],
                  totalSwitches: 2,
                  labels: ['داخلي', 'خارجي'],
                  onToggle: (index) {
                    setState(() {
                      selectedIndexType = index!;
                    });
                  },
                ),
              ),
              SizedBox(height: 15),
              if (selectedIndexType == 0) ...[
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 0
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'درجة الحرارة',
                        style: TextStyle(
                          color: selectedIndexMeasure == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 1
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الرطوبة',
                        style: TextStyle(
                          color: selectedIndexMeasure == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 2
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'ثاني اكسيد الكربون',
                        style: TextStyle(
                          color: selectedIndexMeasure == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (selectedIndexType == 1) ...[
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 0
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'درجة الحرارة',
                        style: TextStyle(
                          color: selectedIndexMeasure == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 1
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الرطوبة',
                        style: TextStyle(
                          color: selectedIndexMeasure == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 2
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الغبار',
                        style: TextStyle(
                          color: selectedIndexMeasure == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],

            //month
            if (selectedIndexDuration == 2) ...[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ToggleSwitch(
                  minWidth: 200.0,
                  minHeight: 50.0,
                  initialLabelIndex: selectedIndexType,
                  activeBgColor: [Color.fromARGB(255, 43, 138, 159)],
                  activeFgColor: Colors.white,
                  inactiveBgColor: const Color.fromARGB(255, 239, 235, 235),
                  inactiveFgColor: Colors.grey[900],
                  totalSwitches: 2,
                  labels: ['داخلي', 'خارجي'],
                  onToggle: (index) {
                    setState(() {
                      selectedIndexType = index!;
                    });
                  },
                ),
              ),
              SizedBox(height: 15),
              if (selectedIndexType == 0) ...[
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 0
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'درجة الحرارة',
                        style: TextStyle(
                          color: selectedIndexMeasure == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 1
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الرطوبة',
                        style: TextStyle(
                          color: selectedIndexMeasure == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 2
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'ثاني اكسيد الكربون',
                        style: TextStyle(
                          color: selectedIndexMeasure == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (selectedIndexType == 1) ...[
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 0
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'درجة الحرارة',
                        style: TextStyle(
                          color: selectedIndexMeasure == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 1
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الرطوبة',
                        style: TextStyle(
                          color: selectedIndexMeasure == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndexMeasure = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndexMeasure == 2
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الغبار',
                        style: TextStyle(
                          color: selectedIndexMeasure == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}