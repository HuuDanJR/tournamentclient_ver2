
import 'package:flutter/material.dart';
import 'package:tournament_client/lib/bar_chart_race.dart';
import 'package:tournament_client/service/service_api.dart';
import 'dart:math' as math;

import 'package:tournament_client/utils/mycolors.dart';

// class BarCharRace extends StatefulWidget {
  

//   @override
//   State<BarCharRace> createState() => _BarCharRaceState();
// }

// class _BarCharRaceState extends State<BarCharRace> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Bar Race Chart',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         // is not restarted.
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: RandomDataExample(),
//     );
//   }
// }

class BarCharRace extends StatefulWidget {
List<List<double>> data;
  BarCharRace({super.key, required this.data});
  @override
  _BarCharRaceState createState() => _BarCharRaceState();
}

class _BarCharRaceState extends State<BarCharRace> {
  final ServiceAPIs serviceAPIs = ServiceAPIs();
  List<List<double>>? data;
  Key? key;
  bool isPlaying = false;
  @override
  void initState() {
    print('INIT STATE');
    data = widget.data;
    // data = generateGoodRandomData(30, 10);
    super.initState();
  }

  // void addRandomRow() {
  //   List<double> newRow =
  //       List.generate(10, (_) => math.Random().nextDouble() * 300);
  //   data!.add(newRow);
  //   setState(() {
  //     data = data;
  //   }); // Update the UI to reflect the new data
  //   // print(data!);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            // FutureBuilder<List<List<double>>>(
            //   future: serviceAPIs.fetchData(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(child: CircularProgressIndicator());
            //     } else if (snapshot.hasError) {
            //       return Center(child: Text('Error: ${snapshot.error}'));
            //     } else {
            //      return
            //     }
            //   },
            // )
            BarChartRace(
      data: data!,
      index: 1,
      selectedIndex: 1,
      initialPlayState: true,
      columnsColor: const [
        Color(0xFFFF9900),
        MyColor.blue_coinbase,
        Color(0xFFA2AAAD),
        MyColor.red,
        Color(0xFF212326),
        MyColor.bedge,
        MyColor.pinkMain,
        MyColor.green_araconda,
        MyColor.red_accent,
        MyColor.yellow_accent,
      ],
      framesPerSecond: 30,
      framesBetweenTwoStates: 30,
      numberOfRactanglesToShow: 10,
      title: "TOP COMPANIES REVENUE",
      // title: "",
      columnsLabel: const [
        "Amazon",
        "Google",
        "Apple",
        "Coca",
        "Huawei",
        "Sony",
        'Pepsi',
        "Samsung",
        "Netflix",
        "Facebook",
      ],
      statesLabel: List.generate(
        30,
        (index) => formatDate(
          DateTime.now().add(
            Duration(days: index),
          ),
        ),
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 24,
      ),
    ));
  }

  List<List<double>> generateGoodRandomData(int nbRows, int nbColumns) {
    List<List<double>> data =
        List.generate(nbRows, (index) => List<double>.filled(nbColumns, 0));
    for (int j = 0; j < nbColumns; j++) {
      data[0][j] = j * 10.0;
      // print(data[0][j]);
    }
    for (int i = 1; i < nbRows; i++) {
      for (int j = 0; j < nbColumns; j++) {
        double calculatedValue = data[i - 1][j] +
            (nbColumns - j) +
            math.Random().nextDouble() * 20 +
            (j == 2 ? 10 : 0);
        data[i][j] = calculatedValue;
      }
    }
    return data;
    // return [
    //   [0.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0],
    // ];
  }

  formatDate(DateTime date) {
    int day = date.day;
    int month = date.month;
    int year = date.year;
    return "${months[month - 1]} $day, $year";
  }
}

List<String> months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

List<String> weekDays = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
];

// BarChartRace(
//   data: model,
//   initialPlayState: true,
//   columnsColor: [
//     Color(0xFFFF9900),
//     MyColor.blue_coinbase,
//     Color(0xFFA2AAAD),
//     MyColor.red,
//     Color(0xFF212326),
//     MyColor.bedge,
//     MyColor.pinkMain,
//     MyColor.green_araconda,
//     MyColor.red_accent,
//     MyColor.yellow_accent,
//   ],
//   framesPerSecond: 60,
//   framesBetweenTwoStates: 30,
//   numberOfRactanglesToShow: 10,
//   title: "TOP COMPANIES REVENUE",
//   // title: "",
//   columnsLabel: [
//     "Amazon",
//     "Google",
//     "Apple",
//     "Coca",
//     "Huawei",
//     "Sony",
//     'Pepsi',
//     "Samsung",
//     "Netflix",
//     "Facebook",
//   ],
//   statesLabel: List.generate(
//     30,
//     (index) => formatDate(
//       DateTime.now().add(
//         Duration(days: index),
//       ),
//     ),
//   ),
//   titleTextStyle: TextStyle(
//     color: Colors.black,
//     fontSize: 24,
//   ),
// );
