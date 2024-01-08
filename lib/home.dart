import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tournament_client/home_future.dart';
import 'package:tournament_client/lib/bar_chart.widget.dart';
import 'package:tournament_client/lib/bar_chart_race.dart';
import 'package:tournament_client/lib/getx/controller.get.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/snackbar.custom.dart';
import 'dart:math' as math;

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.url,
    required this.selectedIndex,
    required this.title,
  }) : super(key: key);

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
  void dispose() {
    socket!.disconnect();
    _streamController.close();
    controllerGetX.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('DID CHANGE HOME');
    
  }

  @override
  void initState() {
    print('INIT HOME');
    //gerenate data
    generateGoodRandomData(2, 10);
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

    socket!.on('eventFromServer', (data) {
      if (data is List<dynamic> && data.isNotEmpty) {
        if (data[0] is List<dynamic>) {
          final List<dynamic> memberList = data[0];
          final List rawData = data;

          final List<List<dynamic>> formattedData = [memberList, ...rawData];

          final List<Map<String, dynamic>> resultData = [];
          final List<String> memberListAsString =
              memberList.map((member) => member.toString()).toList();
          for (int i = 1; i < formattedData.length; i++) {
            final Map<String, dynamic> entry = {
              'member': memberListAsString,
              'data': formattedData[i].map((entry) {
                if (entry is num) {
                  return entry.toDouble();
                }
                return entry;
              }).toList(),
            };
            resultData.add(entry);
          }
          _streamController.add(resultData);
        }
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

  Future<void> _refresh() async {
    socket!.emit('eventFromClient');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // print('snapshotdata: ${snapshot.data}');

              final List<Map<String, dynamic>>? dataList = snapshot.data;
              // print('snapshotdata2 $dataList');
              final List<String> member = dataList![0]['member'].cast<String>();
              final List<dynamic> rawData = dataList[1]['data'];
              print('total length: ${member.length}');
              print('total data 1: ${rawData.first}');
              print('total length2: ${rawData.last.length}');

              double toDouble(dynamic value) {
                if (value is num) {
                  return value.toDouble();
                }
                return 0.0; // Replace with a default value if needed
              }

              final List<List<double>> rawData2 = rawData
                  .map((entry) => entry is List<dynamic>
                      ? entry.map(toDouble).toList()
                      : <double>[])
                  .toList();

              // print('member $member');
              // print('rawData $rawData');
              // print('rawData2 $rawData2');
              if (snapshot.data!.isEmpty ||
                  snapshot.data == null ||
                  snapshot.data == []) {
                return const Text('empty data');
              }

              // return Center(
              //     child: Text(
              //   'sdfasdfa',
              //   style: TextStyle(color: Colors.white),
              // ));
              return Stack(
                children: [
                  BarChartRace(
                    selectedIndex: widget.selectedIndex,
                    // index: 0,
                    // index: widget.selectedIndex,
                    index: detect(
                        widget.selectedIndex!.toDouble(), rawData2.first),
                    data: convertData(rawData2),
                    // data: generateGoodRandomData2(2, 6),
                    initialPlayState: true,
                    // columnsColor: changeList(detect(1, formattedData[0])),
                    // columnsColor: colorList,
                    // columnsColor: shuffleColorList(),
                    framesPerSecond: 40.0,
                    framesBetweenTwoStates: 40,
                    // framesPerSecond: 65,
                    // framesBetweenTwoStates: 65,
                    numberOfRactanglesToShow: member.length, // <= 10
                    title: "",
                    // title: "TOURNAMENT LEADER BOARD",
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
                    columnsLabel: member,
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
                      fontSize: kIsWeb ? 48 : 36.0,
                    ),
                  ),
                  Positioned(
                      bottom: 32,
                      right: 28,
                      child: widget.selectedIndex == MyString.DEFAULTNUMBER
                          ? Container()
                          : Text('YOU ARE PLAYER ${widget.selectedIndex}',
                              style: const TextStyle(
                                color: MyColor.white,
                                fontSize: 18,
                              ))),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                    strokeWidth: .5, color: MyColor.white),
              );
            }
          },
        ),
      ),
    );
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
  }
}

class FormattedDataText extends StatelessWidget {
  final List<List<double>> formattedData;

  const FormattedDataText({Key? key, required this.formattedData})
      : super(key: key);

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
