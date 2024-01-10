import 'dart:math';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:tournament_client/lib/models/stationmodel.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/widget/textfield.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final TextEditingController controllerMember = TextEditingController();
  final TextEditingController controllerMC = TextEditingController();
  final service_api = ServiceAPIs();
  IO.Socket? socket;
  @override
  void initState() {
    debugPrint('INIT SETUPPAGE');
    super.initState();
    socket = IO.io('http://localhost:8090', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket!.onConnect((_) {
      print('Connected to server APP2');
    });
    socket!.onDisconnect((_) {
      print('Disconnected server from setuppage');
    });
    socket!.emit('eventFromClient_force');
  }

  @override
  void dispose() {
    super.dispose();
    socket!.dispose();
  }

  void emitEvent() {
    socket!.emit('eventFromClient_force');
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              debugPrint('add');
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: textcustom(text: "Create New MC Display"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        mytextfield(controller: controllerMember, hint: "Member"),
                        mytextfield(controller: controllerMC, hint: "MC"),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: textcustom(text: "Cancel")),
                      TextButton(
                          onPressed: () {
                            debugPrint('value: ${controllerMember.text} ${controllerMC.text}') ;
                            try {
                              service_api.createStation(
                                member: controllerMember.text,
                                machine: controllerMC.text,
                              ).then((value){
                                setState(() {
                                  controllerMC.text='';
                                  controllerMember.text='';
                                });
                              }).whenComplete(() => Navigator.of(context).pop());
                            } catch (e) {
                              Navigator.of(context).pop();
                            }
                          }, child: textcustom(text: "Submit"))
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.add, color: MyColor.white)),
        appBar: AppBar(
          title: Text('Set Up MC Display'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  print('rebuild realtime rank');
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: textcustom(text: "Re-Build realtime ranking"),
                      content: textcustom(text:"Re-Build realtime ranking will be take action if you click confirm"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              emitEvent();
                              Navigator.of(context).pop();
                            },
                            child: textcustom(text: "Confirm")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: textcustom(text: "Cancel")),
                      ],
                    ),
                  );
                },
                child: textcustom(text: "Re-Build"))
          ],
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
              padding: EdgeInsets.all(0.0),
              height: height,
              width: width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    color: MyColor.grey_tab,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          itemList(
                            width: width,
                            child: textcustom(text: 'ID'),
                          ),
                          itemList(
                            width: width,
                            child: textcustom(text: 'Member'),
                          ),
                          itemList(
                            width: width,
                            child: textcustom(text: 'Machine'),
                          ),
                          itemList(
                            width: width,
                            child: textcustom(text: 'IP'),
                          ),
                          itemList(
                            width: width,
                            child: textcustom(text: 'Credit'),
                          ),
                          itemList(
                              width: width, child: textcustom(text: 'Status')),
                          itemList(width: width, child: textcustom(text: '⚙️')),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                itemList(
                                  width: width,
                                  child: Text('#${index + 1}'),
                                ),
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
                                  child: Text('${model!.list[index].credit / 100}\$'),
                                ),
                                itemList(
                                    width: width,
                                    child: Text(
                                      model!.list[index].connect == 1
                                          ? 'Connected'
                                          : 'Disconnected',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: model!.list[index].connect == 1
                                              ? Colors.green
                                              : Colors.red),
                                    )),
                                Expanded(
                                  child: itemList(
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              //show dialog
                                              showDialogEdit(
                                                  functionFinishDisplay: () {
                                                    print('complete display');
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                  functionFinishUnDisplay: () {
                                                    print(
                                                        'complete  un-display');
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                  context: context,
                                                  service_api: service_api,
                                                  ip: model!.list[index].ip,
                                                  status: model!.list[index].display);
                                            },
                                            icon: Icon(model!.list[index].display ==
                                                    0
                                                ? Icons.close_outlined
                                                : Icons
                                                    .remove_red_eye_rounded)),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        // IconButton(
                                        //     onPressed: () {
                                        //       debugPrint('update');
                                        //     },
                                        //     icon: Icon(Icons.update)),
                                        // SizedBox(
                                        //   width: 8.0,
                                        // ),
                                        IconButton(
                                            onPressed: () {
                                              debugPrint('delete');
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                            title: textcustom(
                                                                text:
                                                                    'Confirm delete'),
                                                            content: textcustom(
                                                                text:
                                                                    "Are you sure to delete this item?"),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: textcustom(
                                                                      text:
                                                                          "Cancel")),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    try {
                                                                      service_api
                                                                          .deleteStation(
                                                                            machine:
                                                                                model.list[index].machine,
                                                                            member:
                                                                                model.list[index].member,
                                                                          )
                                                                          .then((value) =>
                                                                              {
                                                                                setState(() {})
                                                                              })
                                                                          .whenComplete(() =>
                                                                              Navigator.of(context).pop());
                                                                    } catch (e) {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    }
                                                                  },
                                                                  child: textcustom(
                                                                      text:
                                                                          "Submit"))
                                                            ],
                                                          ));
                                            },
                                            icon: const Icon(Icons.delete))
                                      ],
                                    ),
                                  ),
                                )
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
    width: width / 7.25,
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
                        .then((value) => null)
                        .whenComplete(() {
                      functionFinishDisplay();
                    });
                  } else {
                    print('un-display');
                    service_api!
                        .updateDisplayStatus(ip: ip, display: 0)
                        .then((value) => null)
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
