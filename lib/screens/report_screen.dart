import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'Bar Graph/Bar_Graph.dart';

class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  MyBarGraph graph = MyBarGraph();
  int selectedIndex = 0;
  int selectedIndex1 = 0;
  int selectedIndex2 = 0;
  int selectedIndex3 = 0;
  int selectedButtonIndexDI = 0;
  int selectedButtonIndexDO = 0;
  int selectedButtonIndexWI = 0;
  int selectedButtonIndexWO = 0;
  int selectedButtonIndexMI = 0;
  int selectedButtonIndexMO = 0;
  final List Summary = [30.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0];
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
                initialLabelIndex: selectedIndex,
                activeBgColor: [Color.fromARGB(255, 43, 138, 159)],
                activeFgColor: Colors.white,
                inactiveBgColor: const Color.fromARGB(255, 239, 235, 235),
                inactiveFgColor: Colors.grey[900],
                totalSwitches: 3,
                labels: ['يومي', 'اسبوعي', 'شهري'],
                onToggle: (index) {
                  setState(() {
                    selectedIndex = index!;
                  });
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: graph.showTempbar(Summary, selectedIndex, 0)),

            /* SizedBox(height: 350),

            if (selectedIndex == 0) ...[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ToggleSwitch(
                  minWidth: 200.0,
                  minHeight: 50.0,
                  initialLabelIndex: selectedIndex1,
                  activeBgColor: [Color.fromARGB(255, 43, 138, 159)],
                  activeFgColor: Colors.white,
                  inactiveBgColor: const Color.fromARGB(255, 239, 235, 235),
                  inactiveFgColor: Colors.grey[900],
                  totalSwitches: 2,
                  labels: ['داخلي', 'خارجي'],
                  onToggle: (index) {
                    setState(() {
                      selectedIndex1 = index!;
                    });
                  },
                ),
              ),
              SizedBox(height: 15),
              if (selectedIndex1 == 0) ...[
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexDI = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexDI == 0
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'درجة الحرارة',
                        style: TextStyle(
                          color: selectedButtonIndexDI == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexDI = 1;
                          
                        });
                        //////here
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexDI == 1
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الرطوبة',
                        style: TextStyle(
                          color: selectedButtonIndexDI == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexDI = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexDI == 2
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'ثاني اكسيد الكربون',
                        style: TextStyle(
                          color: selectedButtonIndexDI == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (selectedIndex1 == 1) ...[
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexDO = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexDO == 0
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'درجة الحرارة',
                        style: TextStyle(
                          color: selectedButtonIndexDO == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexDO = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexDO == 1
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الرطوبة',
                        style: TextStyle(
                          color: selectedButtonIndexDO == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexDO = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexDO == 2
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الغبار',
                        style: TextStyle(
                          color: selectedButtonIndexDO == 2
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
            if (selectedIndex == 1) ...[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ToggleSwitch(
                  minWidth: 200.0,
                  minHeight: 50.0,
                  initialLabelIndex: selectedIndex2,
                  activeBgColor: [Color.fromARGB(255, 43, 138, 159)],
                  activeFgColor: Colors.white,
                  inactiveBgColor: const Color.fromARGB(255, 239, 235, 235),
                  inactiveFgColor: Colors.grey[900],
                  totalSwitches: 2,
                  labels: ['داخلي', 'خارجي'],
                  onToggle: (index) {
                    setState(() {
                      selectedIndex2 = index!;
                    });
                  },
                ),
              ),
              SizedBox(height: 15),
              if (selectedIndex2 == 0) ...[
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexWI = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexWI == 0
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'درجة الحرارة',
                        style: TextStyle(
                          color: selectedButtonIndexWI == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexWI = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexWI == 1
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الرطوبة',
                        style: TextStyle(
                          color: selectedButtonIndexWI == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexWI = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexWI == 2
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'ثاني اكسيد الكربون',
                        style: TextStyle(
                          color: selectedButtonIndexWI == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (selectedIndex2 == 1) ...[
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexWO = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexWO == 0
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'درجة الحرارة',
                        style: TextStyle(
                          color: selectedButtonIndexWO == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexWO = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexWO == 1
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الرطوبة',
                        style: TextStyle(
                          color: selectedButtonIndexWO == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexWO = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexWO == 2
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الغبار',
                        style: TextStyle(
                          color: selectedButtonIndexWO == 2
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
            if (selectedIndex == 2) ...[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ToggleSwitch(
                  minWidth: 200.0,
                  minHeight: 50.0,
                  initialLabelIndex: selectedIndex3,
                  activeBgColor: [Color.fromARGB(255, 43, 138, 159)],
                  activeFgColor: Colors.white,
                  inactiveBgColor: const Color.fromARGB(255, 239, 235, 235),
                  inactiveFgColor: Colors.grey[900],
                  totalSwitches: 2,
                  labels: ['داخلي', 'خارجي'],
                  onToggle: (index) {
                    setState(() {
                      selectedIndex3 = index!;
                    });
                  },
                ),
              ),
              SizedBox(height: 15),
              if (selectedIndex3 == 0) ...[
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexMI = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexMI == 0
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'درجة الحرارة',
                        style: TextStyle(
                          color: selectedButtonIndexMI == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexMI = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexMI == 1
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الرطوبة',
                        style: TextStyle(
                          color: selectedButtonIndexMI == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexMI = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexMI == 2
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'ثاني اكسيد الكربون',
                        style: TextStyle(
                          color: selectedButtonIndexMI == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (selectedIndex3 == 1) ...[
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexMO = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexMO == 0
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'درجة الحرارة',
                        style: TextStyle(
                          color: selectedButtonIndexMO == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexMO = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexDO == 1
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الرطوبة',
                        style: TextStyle(
                          color: selectedButtonIndexMO == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButtonIndexMO = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selectedButtonIndexMO == 2
                            ? Color.fromARGB(255, 43, 138, 159)
                            : Color.fromARGB(255, 227, 224, 224),
                        fixedSize: Size(352, 50),
                      ),
                      child: Text(
                        'مستوى الغبار',
                        style: TextStyle(
                          color: selectedButtonIndexMO == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],*/
          ],
        ),
      ),
    );
  }
}
