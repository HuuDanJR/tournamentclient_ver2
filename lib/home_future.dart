import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tournament_client/lib/bar_chart.widget.dart';
import 'package:tournament_client/lib/bar_chart_race.dart';
import 'package:tournament_client/utils/mycolors.dart';

class MyHomeFuture extends StatefulWidget {
  const MyHomeFuture({super.key, required this.title});

  final String title;

  @override
  State<MyHomeFuture> createState() => _MyHomeFutureState();
}

class _MyHomeFutureState extends State<MyHomeFuture> {
  late IO.Socket socket;
  
  Future<List<Map<String, dynamic>>> _initializeSocket() async {
    socket = IO.io('http://192.168.101.58:8099', <String, dynamic>{
      'transports': ['websocket'],
    });
    
    socket.onConnect((_) {
      print('Connected to server');
    });
    socket.onDisconnect((_) {
      print('Disconnected from server');
    });
    
    socket.connect(); // Await the connection
    
    socket.emit('eventFromClient');

    final completer = Completer<List<Map<String, dynamic>>>();

    socket.on('eventFromServer', (data) {
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
            print('stationData: $stationData');
          }
        }

        List<Map<String, dynamic>> formattedData = stationData.map((list) {
          return {'data': List<double>.from(list)};
        }).toList();

        completer.complete(formattedData);
      }
    });

    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }
   Future<void> _refresh() async {
    socket.emit('eventFromClient');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: 
       FutureBuilder<List<Map<String, dynamic>>>(
      future: _initializeSocket(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        }  
        if (snapshot.hasData) {
              final stationDataList = snapshot.data!;
              final formattedData =
                  stationDataList.map<List<double>>((dataMap) {
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
                    child: BarChartRace(selectedIndex: 1,
                      index: detect(1, formattedData[0]),
                      // index:0,
                      data: convertData(formattedData),
                      initialPlayState: true,
                      // columnsColor: changeList(detect(1, formattedData[0])),
                      // columnsColor: colorList,
                      // columnsColor: shuffleColorList(),
                      framesPerSecond: 90,
                      framesBetweenTwoStates: 90,
                      numberOfRactanglesToShow: formattedData[0].length,
                      title: "DYNAMIC RANKING",
                      columnsLabel: formattedData[0].map((value) =>'PLAYER ${value < 10 ? '0$value' : value.toStringAsFixed(0)}').toList(),
                      statesLabel: List.generate(
                        30,
                        (index) => formatDate(
                          DateTime.now().add(
                            Duration(days: index),
                          ),
                        ),
                      ),
                      titleTextStyle: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontSize: 32,
                      ),
                    )),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
      },
    )
      ),
    );
  }
}

List<List<double>> convertData(data) {
  if (data.length == 2) {
    return [data.last];
  } else if (data.length == 3) {
    return [data[1], data.last];
  }
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
  print(colorList);
  return colorList;
}

int detect(double targetIndex, List<double> myList) {
  for (int i = 0; i < myList.length; i++) {
    if (myList[i] == targetIndex) {
      print('index $i');
      return i;
    }
  }
  return -1; // Return -1 if the index is not found in the list
}

List<Color> shuffleColorList() {
  final random = Random();
  const sublistLength = 10;
  final shuffledList = colorList.sublist(0, sublistLength)..shuffle(random);
  // Create a new list with the shuffled sublist
  final newList = List<Color>.from(colorList);
  for (int i = 0; i < sublistLength; i++) {
    newList[i] = shuffledList[i];
  }
  return newList;
}
