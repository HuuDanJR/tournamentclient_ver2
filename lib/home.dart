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
import 'package:tournament_client/utils/functions.dart';
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
  late StreamController<List<Map<String, dynamic>>> _streamController =
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
    // generateGoodRandomData2(3, 10);
    super.initState();
    socket = IO.io(widget.url, <String, dynamic>{
      'transports': ['websocket'],
    });
    socket!.onConnect((_) {
      print('Connected socket');
    });
    socket!.onDisconnect((_) {
      print('Disconnected socket');
    });

    socket!.on('eventFromServer', (data) {
      if (data is List<dynamic> && data.isNotEmpty) {
        if (data[0] is List<dynamic>) {
          late List<dynamic> memberList = data[0];
          late List rawData = data;
          late List<List<dynamic>> formattedData = [memberList, ...rawData];
          late List<Map<String, dynamic>> resultData = [];
          late List<String> memberListAsString =
              memberList.map((member) => member.toString()).toList();
          for (int i = 1; i < formattedData.length; i++) {
            late Map<String, dynamic> entry = {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<Map<String, dynamic>>? dataList = snapshot.data;
              final List<String> member = dataList![0]['member'].cast<String>();
              final List<dynamic> rawData = dataList![1]['data'];
              print('total member: ${member}');
              print('total data first: ${rawData.first}');
              print('total data last: ${rawData.last}');

              final List<List<double>> rawData2 = rawData
                  .map((entry) => entry is List<dynamic>
                      ? entry.map(toDoubleFunc).toList()
                      : <double>[])
                  .toList();
              print('total data proccessed 1st: ${rawData2.first.length}');
              print('total data proccessed 1st: ${rawData2.first}');
              print('total data proccessed last: ${rawData2.last.length}');
              if (snapshot.data!.isEmpty ||
                  snapshot.data == null ||
                  snapshot.data == []) {
                return const Text('empty data');
              }
              print('data will be marked yellow: ${rawData2.first}');
              return Stack(
                children: [
                  BarChartRace(
                    selectedIndex: widget.selectedIndex,
                    // index: 0,
                    // index: widget.selectedIndex,
                    index:detect(widget.selectedIndex!.toDouble(), rawData2.first),
                    data: convertData(rawData2),
                    // data: (generateNewData(rawData2)),
                    // data: generateGoodRandomData2(2, 10),
                    initialPlayState: true,
                    framesPerSecond: 65.0,
                    framesBetweenTwoStates: 65,
                    // numberOfRactanglesToShow: 10, // <= 10
                    numberOfRactanglesToShow: rawData2.last.length, // <= 10
                    title: "",
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
}

double toDoubleFunc(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  return 0.0; // Replace with a default value if needed
}
