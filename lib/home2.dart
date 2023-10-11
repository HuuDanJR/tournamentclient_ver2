import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/widget/snackbar.custom.dart';
import 'package:tournament_client/widget/text.dart';

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  String? url ='https://cdn.pixabay.com/photo/2023/07/10/06/13/mountain-8117525_1280.jpg';

  IO.Socket? socket;
  final StreamController<List<Map<String, dynamic>>> _streamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  List<Map<String, dynamic>> stationData = [];
  final Map<String, AnimationController> _animationControllers = {};

  @override
  void initState() {
    super.initState();
    socket = IO.io('http://30.0.0.82:8090', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket!.onConnect((_) {
      print('Connected to server');
    });
    socket!.onDisconnect((_) {
      print('Disconnected from server');
    });
    socket!.on('eventFromServer', (data) {
      // print('Received data from server: $data');
      List<Map<String, dynamic>> stationData =
          List<Map<String, dynamic>>.from(data);
      _streamController.add(stationData);
    });

    socket!.emit('eventFromClient');
  }

  void _delete(int stationId) {
    // Emit an event to the server for delete with the given stationId
    socket!.emit('eventFromClientDelete', {'stationId': stationId});
    String message = 'Data deleted with stationId $stationId';
    snackbar_custom(context: context, text: message);
  }

  void _create() {
    // Emit an event to the server for delete with the given stationId
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
    // Disconnect from the socket.io server when the widget is disposed
    socket!.disconnect();
    _streamController.close();
    super.dispose();
  }

  Future<void> _refresh() async {
    socket!.emit('eventFromClient');
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final widthP = width - 84;
    const double itemWidth = 65;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  "asset/meteor-rain.gif",
                  height: 37.5,
                  width: 37.5,
                ),
                const SizedBox(
                  width: 8,
                ),
                textcustom(text: 'LEADER BOARD', size: 26, isBold: true),
              ],
            ),
            textcustom(
                text:
                    'Vegas roulette tournament leader board present as list below for 10 players',
                size: 14,
                isBold: false),
            // Divider(color: MyColor.grey_tab),
            Expanded(
                child: body(
              height: height * .8,
              width: widthP,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final stationData = snapshot.data!;
                    return ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        physics: const BouncingScrollPhysics(),
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.trackpad
                        },
                      ),
                      child: RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) => itemListView(
                              color: index == 0
                                  ? MyColor.black_text
                                  : index == 1
                                      ? MyColor.black_text
                                      : index == 2
                                          ? MyColor.black_text
                                          : MyColor.grey,
                              index: index + 1,
                              isOdd: index % 2 == 0 ? true : false,
                              isBotItem:
                                  index == stationData.last ? true : false,
                              isTopItem:
                                  index == stationData.first ? true : false,
                              width: widthP * .65,
                              height: itemWidth,
                              itemWidth: itemWidth,
                              member: stationData[index]['member'],
                              machine: stationData[index]['machine'],
                              credit: stationData[index]['credit'],
                              bet: stationData[index]['bet'],
                              assetname:index == 0
                                  ? 'asset/medal.png'
                                  : index == 1
                                      ? 'asset/winner.png'
                                      : index == 2
                                          ? 'asset/silver.png'
                                          : 'asset/no_image.png',
                              colorBorder:  index == 0
                                  ? MyColor.red_japanguild
                                  : index == 1
                                      ? MyColor.green_araconda
                                      : index == 2
                                          ? MyColor.blue_coinbase
                                          : MyColor.grey_tab,
                            ),
                          )),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ))
          ],
        ),
      )),
    );
  }

  Widget body({width, height, child}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: width * .65,
          height: height,
          child: child,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: MyColor.grey_tab)),
        ),
        Container(
          width: width * .35,
          height: height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("$url"), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: MyColor.grey_tab)),
        ),
      ],
    );
  }

  Widget itemListView(
      {width,
      height,
      color,
      isOdd,assetname,
      isTopItem,
      machine,bet,credit,
      isBotItem,
      index,colorBorder,
      itemWidth,
      member}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: colorBorder),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              itemContainer(assetname: assetname, colorBorder: colorBorder, isLargeText: false, color:color,height:height,width: width/10,text: '$index',),
              itemContainer(assetname: assetname, hasChildMore: true, colorBorder: colorBorder, color:color,height:height,width: width*3/10,text: '$member',),
              itemContainer(assetname: assetname, colorBorder: colorBorder, color:color,height:height,width: width*2/10,text: '$machine',),
              itemContainer(assetname: assetname, colorBorder: colorBorder, color:color,height:height,width: width*2/10,text: '$bet',),
              Expanded(child: itemContainer(assetname: assetname, colorBorder: colorBorder, color:color,height:height,width: width*2/10,text: '$credit',)),
            ],
          ),
        ),
      ],
    );
  }

  Widget itemContainer({width, text, height,color,isLargeText=false,colorBorder,hasChildMore=false,assetname}) {
    return Stack(
      alignment: Alignment.center,
      children: [
       hasChildMore==true? Positioned(
        right: 16,
        child: Image.asset(
                  "$assetname",
                  height: 37.5,
                  width: 37.5,
                ),):Container(),
        Container(
        width: width ,
        alignment: Alignment.center,
        height: height,
        decoration: const BoxDecoration(
            border: Border(
          right: BorderSide(
            color: MyColor.grey_tab, // Border color
            width: 1.0, // Border width
          ),
        )),
        child: textcustomColor( text: '$text', size:isLargeText==true? 22:16, isBold: false, color: color),
      ),
      ]
    );
  }
}
