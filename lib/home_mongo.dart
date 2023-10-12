import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tournament_client/home.dart';
import 'package:tournament_client/lib/bar_chart.widget.dart';
import 'package:tournament_client/lib/bar_chart_race.dart';
import 'package:tournament_client/lib/getx/controller.get.dart';
import 'package:tournament_client/utils/functions.dart';
import 'package:tournament_client/utils/mycolors.dart';

// ignore: must_be_immutable
class MyHomePageMongo extends StatefulWidget {
  MyHomePageMongo({
    super.key,
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
  final controllerGetX = Get.put(MyGetXController());

  @override
  void initState() {
    super.initState();
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
          print('final $finalFormattedData');

          _streamController.add([finalFormattedData]);
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty ||
                snapshot.data == null ||
                snapshot.data == []) {
              return const Text('empty data');
            }

            final List<Map<String, dynamic>>? data = snapshot.data;
            if (data == null || data.isEmpty) {
              return const Text('empty data');
            }
            final List<String> names = data![0]['name'].cast<String>();
            final List<int> numbers = data![0]['number'].map<int>((number) => int.tryParse(number.toString()) ?? 0).toList();
            final List<List<double>> dataField = List.castFrom(data[0]['data']).map<List<double>>((item) => List.castFrom(item)).toList();    

            
            return Stack(
              children: [
                BarChartRace(
                  // selectedIndex: widget.selectedIndex,
                  // index: detectInt(widget.selectedIndex!.toDouble(), numbers),
                  selectedIndex: 5,
                  index: 5,
                  data: convertData(dataField),
                  initialPlayState: true,
                  framesPerSecond: 40,
                  framesBetweenTwoStates: 40,
                  numberOfRactanglesToShow: numbers.length ,
                  title: "TOURNAMENT LEADER BOARD",
                  columnsLabel: names,
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
                              fontSize: 26,
                  ),
                ),

                // Positioned(
                //           bottom: 12,
                //           right: 12,
                //           child: widget.selectedIndex==111111?Container(): Text('YOU ARE PLAYER ${widget.selectedIndex}',
                //               style: const TextStyle(
                //                 color: MyColor.white,
                //                 fontSize: 24,
                // ))),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error orcur'));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ));
  }
}
