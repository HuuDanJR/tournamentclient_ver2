import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tournament_client/lib/models/stationmodel.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:video_player/video_player.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final service_api = ServiceAPIs();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Set Up MC Display'),
        ),
        body: FutureBuilder(
          future: service_api.listStationData(),
          builder: (BuildContext context,
              AsyncSnapshot<ListStationModel?> snapshot) {
            if (snapshot.hasError) {
              return Text('An Error Orcur!');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final ListStationModel? model = snapshot.data;
            return Container(
              height: height,
              width: width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Card(
                      color:MyColor.red_bg,
                      child: ListTile(
                        trailing: Text('Display'),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            itemList(
                              width: width,
                              child: Text('Member'),
                            ),
                            itemList(
                              width: width,
                              child: Text('Machine'),
                            ),
                            itemList(
                              width: width,
                              child: Text('IP'),
                            ),
                            itemList(
                              width: width,
                              child: Text('Credit'),
                            ),
                            itemList(width: width, child: Text('Status')),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            trailing: IconButton(
                                onPressed: () {
                                  //show dialog
                                  showDialogEdit(
                                      functionFinishDisplay: () {
                                        print('complete display');
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                      functionFinishUnDisplay: () {
                                        print('complete  un-display');
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                      context: context,
                                      service_api: service_api,
                                      ip: model!.list[index].ip,
                                      status: model!.list[index].display);
                                },
                                icon: Icon(model!.list[index].display == 0
                                    ? Icons.close_outlined
                                    : Icons.remove_red_eye_rounded)),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                itemList(
                                  width: width,
                                  child: Text('${model!.list[index].member}'),
                                ),
                                itemList(
                                  width: width,
                                  child: Text('${model!.list[index].machine}'),
                                ),
                                itemList(
                                  width: width,
                                  child: Text('${model!.list[index].ip}'),
                                ),
                                itemList(
                                  width: width,
                                  child: Text('${model!.list[index].credit} '),
                                ),
                                itemList(
                                    width: width,
                                    child: Text(
                                      model!.list[index].connect == 1
                                          ? 'Connected'
                                          : 'Disconnected',
                                      style: TextStyle(
                                          color: model!.list[index].connect == 1
                                              ? Colors.green
                                              : Colors.red),
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: model!.list.length,
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}

Widget itemList({width, child}) {
  return Container(
    alignment: Alignment.centerLeft,
    width: width / 5.75,
    child: Center(child: child),
  );
}

showDialogEdit(
    {context,
    status,
    ServiceAPIs? service_api,
    ip,
    functionFinishDisplay,
    functionFinishUnDisplay}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Update Status'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: Text(
                  status == 0 ? "DISPLAY" : "UN-DISPLAY",
                  style: TextStyle(
                      color: status == 0 ? Colors.green : Colors.pink),
                ),
                onPressed: () {
                  if (status == 0) {
                    print('display');
                    service_api!
                        .updateDisplayStatus(ip: ip, display: 1)
                        .then((value) => print(value))
                        .whenComplete(() {
                      functionFinishDisplay();
                    });
                  } else {
                    print('un-display');
                    service_api!
                        .updateDisplayStatus(ip: ip, display: 0)
                        .then((value) => print(value))
                        .whenComplete(() {
                      functionFinishUnDisplay();
                    });
                  }
                },
              ),
              TextButton(
                child: const Text("CANCEL"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        ],
        content: const Text("Status will be apply for mobile and web"),
      );
    },
  );
}
