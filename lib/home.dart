import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tournament_client/lib/bar_chart.widget.dart';
import 'package:tournament_client/lib/bar_chart_race.dart';
import 'package:tournament_client/lib/getx/controller.get.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/widget/snackbar.custom.dart';
import 'dart:math' as math;

class MyHomePage extends StatefulWidget {
  MyHomePage(
      {super.key,
      required this.url,
      required this.selectedIndex,
      required this.title,
      }
  );

  final String title;
  int? selectedIndex;
  final String url;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  IO.Socket? socket;
  final StreamController<List<Map<String, dynamic>>> _streamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  List<Map<String, dynamic>> stationData = [];
  final Map<String, AnimationController> _animationControllers = {};
  final controllerGetX = Get.put(MyGetXController());

  @override
  void initState() {
    //gerenate data
    // generateGoodRandomData(3, 10);
    // generateGoodRandomData2(3, 10);

    super.initState();
    socket = IO.io(widget.url, <String, dynamic>{
      'transports': ['websocket'],
    });
    socket!.onConnect((_) {
      print('Connected to server APP');
    });
    socket!.onDisconnect((_) {
      print('Disconnected from server APP');
    });
    // socket!.on('eventFromServer', (data) {
    //   List<Map<String, dynamic>> stationData = List<Map<String, dynamic>>.from(data);
    //   _streamController.add(stationData);
    // });
    socket!.on('eventFromServer', (data) {
      if (data is List<dynamic>) {
        List<List<double>> stationData = [];

        for (dynamic item in data) {
          if (item is List<dynamic>) {
            List<double> doubleList = [];
            for (dynamic value in item) {
              if (value is num) {
                doubleList.add(value.toDouble());
              }
            }
            stationData.add(doubleList);
            // print('stationData_: ${stationData}');
          }
        }

        List<Map<String, dynamic>> formattedData = stationData.map((list) {
          return {'data': List<double>.from(list)};
        }).toList();
        // print('formatData in home: $formattedData');

        _streamController.add(formattedData);
        final finalData = formattedData.map<List<double>>((dataMap) {
          if (dataMap['data'] is List<double>) {
            final dataList = dataMap['data'] as List<double>;
            return dataList;
          }
          return [];
        }).toList();
        // setState(() {
        //   widget.selectedIndex = (detect(1, finalData[0]));
        //   // print('selected index: ${widget.selectedIndex}');
        // });
      }
    });

    socket!.emit('eventFromClient');
  }

  void _delete(int stationId) {
    socket!.emit('eventFromClientDelete', {'stationId': stationId});
    String message = 'Data deleted with stationId $stationId';
    snackbar_custom(context: context, text: message);
  }

  void _create() {
    socket!.emit('eventFromClientAdd', {
      "machine": "RL-TEST",
      "member": "1",
      "bet": "799999",
      "credit": "799999",
      "connect": "1",
      "status": "0",
      "aft": "0",
      "lastupdate": "2023-07-28"
    });
    String message = 'Created an record';
    snackbar_custom(context: context, text: message);
  }

  @override
  void dispose() {
    socket!.disconnect();
    _streamController.close();
    controllerGetX.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    socket!.emit('eventFromClient');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final stationDataList = snapshot.data!;
            final formattedData = stationDataList.map<List<double>>((dataMap) {
              if (dataMap['data'] is List<double>) {
                final dataList = dataMap['data'] as List<double>;
                return dataList;
              }
              return [];
            }).toList();
            if (snapshot.data!.isEmpty ||
                snapshot.data == null ||
                snapshot.data == []) {
              return const Text('empty data');
            }

            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                physics: const BouncingScrollPhysics(),
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
              ),
              child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: Stack(
                    children: [
                      BarChartRace(
                        selectedIndex: widget.selectedIndex,
                        // index: 1,
                        // index: selectedIndex,
                        index: detect(
                            widget.selectedIndex!.toDouble(), formattedData[0]),
                        data: convertData(formattedData),
                        // data: generateGoodRandomData2(2, 6),
                        initialPlayState: true,
                        // columnsColor: changeList(detect(1, formattedData[0])),
                        // columnsColor: colorList,
                        // columnsColor: shuffleColorList(),
                        framesPerSecond: 40,
                        framesBetweenTwoStates: 40,
                        numberOfRactanglesToShow: formattedData[0].length,
                        title: "DYNAMIC RANKING",
                        // columnsLabel: [
                        //   "1232123132141",
                        //   "3123",
                        //   "Apple213",
                        //   "Coca123",
                        //   "Huawei123",
                        //   "Sony",
                        //   'Pepsi',
                        //   "Samsung",
                        //   "Netflix",
                        //   "Facebook",
                        // ],
                        columnsLabel: formattedData[0]
                            .map((value) =>
                                'PLAYER ${value < 10 ? '0$value' : value.toStringAsFixed(0)}')
                            .toList(),
                        statesLabel: List.generate(
                          30,
                          (index) => formatDate(
                            DateTime.now().add(
                              Duration(days: index),
                            ),
                          ),
                        ),
                        titleTextStyle: GoogleFonts.nunitoSans(
                          color: Colors.white,
                          fontSize: 36,
                        ),
                      ),
                      Positioned(
                          bottom: 24,
                          right: 24,
                          child: widget.selectedIndex==111111?Container(): Text('YOU ARE PLAYER ${widget.selectedIndex}',
                              style: const TextStyle(
                                color: MyColor.white,
                                fontSize: 24,
                              ))),
                      Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            alignment: Alignment.center,
                            width: 135,
                            height: 55,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('asset/image/logo_new.png'),
                                    fit: BoxFit.contain)),
                          )),
                    ],
                  )),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    )
        // barcharcustom(formattedData)
        // BarCharRace(data: formattedData,)
        // StreamBuilder<List<Map<String, dynamic>>>(
        //   stream: _streamController.stream,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       final stationData = snapshot.data!;
        //       return ScrollConfiguration(
        //         behavior: ScrollConfiguration.of(context).copyWith(
        //           physics: const BouncingScrollPhysics(),
        //           dragDevices: {
        //             PointerDeviceKind.touch,
        //             PointerDeviceKind.mouse,
        //             PointerDeviceKind.trackpad
        //           },
        //         ),
        //         child: RefreshIndicator(
        //             onRefresh: _refresh, child: Text('$stationData')
        //             // ExamplePage(data: stationData)
        //             ),
        //       );
        //     } else {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //   },
        // ),
        );
  }
}

List<List<double>> convertData(data) {
  if (data.length == 2) {
    // print('convert data 2 : $data ');
    return [data.last];
  } else if (data.length == 3) {
    // print('convert data 3: $data ');
    return [data[1], data.last];
  }
  print('convert data : $data ');
  return data;
}

class FormattedDataText extends StatelessWidget {
  final List<List<double>> formattedData;

  const FormattedDataText({super.key, required this.formattedData});

  @override
  Widget build(BuildContext context) {
    return Text('$formattedData');
  }
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

List<Color> changeList(int index) {
  if (index < 0 || index >= 10) {
    throw ArgumentError('Invalid index. Index should be between 0 and 9.');
  }

  List<Color> colorList = List.generate(10, (i) => MyColor.orang3);
  colorList[index] = MyColor.green_araconda;
  return colorList;
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
