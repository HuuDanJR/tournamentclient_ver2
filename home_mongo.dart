import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tournament_client/lib/bar_chart.widget.dart';
import 'package:tournament_client/lib/bar_chart_race.dart';
import 'package:tournament_client/lib/getx/controller.get.dart';
import 'package:tournament_client/utils/functions.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
class MyHomePageMongo extends StatefulWidget {
  MyHomePageMongo({
    key,
    required this.url,
    required this.selectedIndex,
    required this.title,
  });
  final String title;
  int? selectedIndex;
  final String url;
  @override
  State<MyHomePageMongo> createState() => _MyHomePageMongoState();
}

class _MyHomePageMongoState extends State<MyHomePageMongo> {
  IO.Socket? socket;
  final StreamController<List<Map<String, dynamic>>> _streamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  // final List<List<double>> listdefault = generateGoodRandomData(2, 10);
  final controllerGetX = Get.put(MyGetXController());

  @override
  void initState() {
    super.initState();
    print('home mongo url: ${widget.url}');
    socket = IO.io(widget.url, <String, dynamic>{
      'transports': ['websocket'],
    });
    socket!.onConnect((_) {
      print('Connected to server APP2');
    });
    socket!.onDisconnect((_) {
      print('Disconnected from server APP2');
    });

    socket!.on('eventFromServerMongo', (data) {
      final Map<String, dynamic>? jsonData = data as Map<String, dynamic>?;

      if (jsonData != null) {
        final List<dynamic>? dataList = jsonData['data'] as List<dynamic>?;
        final List<dynamic>? nameList = jsonData['name'] as List<dynamic>?;
        final List<dynamic>? numberList = jsonData['number'] as List<dynamic>?;

        if (dataList != null && nameList != null) {
          final Map<String, dynamic> finalFormattedData = {
            'data': dataList,
            'name': nameList,
            'number': numberList,
          };
          List<Map<String, dynamic>> listOfMaps = [finalFormattedData];
          // print('final $listOfMaps');
          _streamController.add(listOfMaps);
        }

        // Create a new formatted map
      }
    });
    socket!.emit('eventFromClient');
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
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                      strokeWidth: .5, color: MyColor.white),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty ||
                    snapshot.data == null ||
                    snapshot.data == []) {
                  return const Text('empty data');
                }

                final List<Map<String, dynamic>>? data = snapshot.data;
                final List<String> names = data![0]['name'].cast<String>();
                final updatedNames = names.map((name) => "Mr. $name").toList();
                final List<int> numbers = data[0]['number']
                    .map<int>((number) => int.tryParse(number.toString()) ?? 0)
                    .toList();
           
                // final List<List<double>> dataField = List<List<double>>.from(data[0]['data'].map<List<double>>((item) => List<double>.from(item)));
                
final List<List<double>> dataField2 = List<List<double>>.from(data[0]['data'].map<List<double>>((item) =>
    List<double>.from(item.map((value) => value.toDouble()))));


// return Center(child: Text('abc $dataField2'));

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: Stack(
                    children: [
                      // Text('data')
                      BarChartRace(
                        selectedIndex: widget.selectedIndex,
                        index: detectInt(widget.selectedIndex!.toDouble(), numbers),
                        data: convertData(dataField2),
                        initialPlayState: true,
                        framesPerSecond: 65.0,
                        framesBetweenTwoStates: 65,
                        numberOfRactanglesToShow: numbers.length,
                        title: "",
                        // title: "TOURNAMENT LEADER BOARD",
                        columnsLabel: updatedNames,
                        // columnsLabel: names,
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
                          fontSize: 36.0,
                        ),
                      ),
                      // Positioned(
                      //     bottom: 12,
                      //     right: 12,
                      //     child: widget.selectedIndex == 111111
                      //         ? Container()
                      //         : Text('YOU ARE PLAYER ${widget.selectedIndex}',
                      //             style: const TextStyle(
                      //               color: MyColor.white,
                      //               fontSize: 24,
                      //             ))),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('An error orcur'));
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                      strokeWidth: .5, color: MyColor.white),
                );
              }
            },
          ),
        ));
  }
}

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
  print(data);
  return data;
}

List<List<double>> convertData(data) {
  if (data.length == 2) {
    // print('convert data 2 : $data ');
    return [data.last];
  } else if (data.length == 3) {
    // print('convert data 3: $data ');
    return [data[1], data.last];
  }
  // print('convert data : $data ');
  return data;
}
