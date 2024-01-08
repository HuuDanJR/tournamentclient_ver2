import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mycolors.dart';

List<Color> shuffleColorList() {
  final random = Random();
  const sublistLength = 10;
  // Make sure the sublist length doesn't exceed the length of the color list
  final shuffledList = colorList.sublist(0, sublistLength)..shuffle(random);
  // Create a new list with the shuffled sublist
  final newList = List<Color>.from(colorList);
  for (int i = 0; i < sublistLength; i++) {
    newList[i] = shuffledList[i];
  }
  return newList;
}

// [
//  "Amazon",
//   "Google",
//   "Apple",
//   "Coca",
//   "Huawei",
//   "Sony",
//   'Pepsi',
//   "Samsung",
//   "Netflix",
//   "Facebook",
// ],

List<List<double>> generateGoodRandomData(int nbRows, int nbColumns) {
  List<List<double>> data =
      List.generate(nbRows, (index) => List<double>.filled(nbColumns, 0));
  for (int j = 0; j < nbColumns; j++) {
    data[0][j] = j * 10.0;
  }
  for (int i = 1; i < nbRows; i++) {
    for (int j = 0; j < nbColumns; j++) {
      double calculatedValue = data[i - 1][j] +
          (nbColumns - j) +
          math.Random().nextDouble() * 20 +
          (j == 2 ? 10 : 0);
      data[i][j] = calculatedValue;
      // print('calculate value: $calculatedValue');
    }
  }
  // print(data);
  return data;
}

List<List<double>> generateGoodRandomData2(int nbRows, int nbColumns) {
  List<List<double>> data =
      List.generate(nbRows, (index) => List<double>.filled(nbColumns, 0));

  for (int j = 0; j < nbColumns; j++) {
    data[0][j] = j * 10.0;
  }

  for (int i = 1; i < nbRows; i++) {
    for (int j = 0; j < nbColumns; j++) {
      double calculatedValue = data[i - 1][j] +
          (nbColumns - j) +
          math.Random().nextDouble() * 20 +
          (j == 2 ? 10 : 0);
      data[i][j] = calculatedValue;
    }

    // Shuffle the values in the current row
    data[i].shuffle();
  }
  // print('data shufffe $data');
  return data;
}

int detect(double targetIndex, List<double> myList) {
  for (int i = 0; i < myList.length; i++) {
    if (myList[i] == targetIndex) {
      // print('index $i');
      return i;
    }
  }
  return -1; // Return -1 if the index is not found in the list
}

List<Color> changeList(int index) {
  if (index < 0 || index >= 10) {
    throw ArgumentError('Invalid index. Index should be between 0 and 9.');
  }

  List<Color> colorList = List.generate(10, (i) => MyColor.orang3);
  colorList[index] = MyColor.green_araconda;
  return colorList;
}

List<Color> colorList = [
  MyColor.green_araconda,
  MyColor.orang3,
  MyColor.orang3,
  MyColor.orang3,
  MyColor.orang3,
  MyColor.orang3,
  MyColor.orang3,
  MyColor.orang3,
  MyColor.orang3,
  MyColor.orang3,
];

class FormattedDataText extends StatelessWidget {
  final List<List<double>> formattedData;

  const FormattedDataText({Key? key, required this.formattedData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('$formattedData');
  }
}

// ignore: unused_element
Future<void> _refresh(socket) async {
  socket!.emit('eventFromClient');
}

int detectInt(List<int> numbers, List<String> times,double targetNumber, List<int> myList) {
  DateTime latestTime = DateTime(2000); // An arbitrary initial date

  int latestIndex = -1; // Initialize with an invalid index

  for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] == targetNumber) {
      final String timeStr = times[i];
      final DateTime time = DateTime.parse(timeStr);

      if (time.isAfter(latestTime)) {
        latestTime = time;
        latestIndex = i;
      }
    }
  }
  // print('latestIndex $latestIndex');
  // return latestIndex;

  for (int i = 0; i < myList.length; i++) {
    if (myList[i] == targetNumber) {
      // print('index $i');
        print('index in list: $i');
      return i;
    }
  }

  return -1; // Return -1 if the index is not found in the list
}

int findLatestTimeIndexForNumber(List<int> numbers, List<String> times, int targetNumber) {
  DateTime latestTime = DateTime(2000); // An arbitrary initial date

  int latestIndex = -1; // Initialize with an invalid index

  for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] == targetNumber) {
      final String timeStr = times[i];
      final DateTime time = DateTime.parse(timeStr);

      if (time.isAfter(latestTime)) {
        latestTime = time;
        latestIndex = i;
      }
    }
  }
  print('latestIndex $latestIndex');
  return latestIndex;
}



// socket!.on('eventFromServerMongo', (data) {
      // final Map<String, dynamic>? jsonData = data as Map<String, dynamic>?;

      // if (jsonData != null) {
      //   final List<dynamic>? dataList = jsonData['data'] as List<dynamic>?;
      //   final List<dynamic>? nameList = jsonData['name'] as List<dynamic>?;

      //   if (dataList != null && nameList != null) {
      //     final List<Map<String, dynamic>> formattedData = [];

      //     for (int i = 0; i < dataList.length; i++) {
      //       formattedData.add({
      //         'data': dataList[i],
      //         'name': nameList[i],
      //         'number': i + 1,
      //       });
      //     }

      //     final List<double> dataNumbers =
      //         formattedData.map((entry) => entry['data'] as double).toList();
      //     final List<String> nameNumbers =
      //         formattedData.map((entry) => entry['name'] as String).toList();
      //     final List<int> numberList =List.generate(formattedData.length, (i) => i + 1);

      //     final List<Map<String, dynamic>> finalFormattedData = [
      //       {
      //         'data': dataNumbers,
      //         'name': nameNumbers,
      //         'number': numberList,
      //       }
      //     ];
      //     print('final $finalFormattedData');

      //     _streamController.add(finalFormattedData);
      //   }
      // }
//     });





