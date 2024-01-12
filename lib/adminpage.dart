import 'package:flutter/material.dart';
import 'package:tournament_client/lib/models/rankingmodel.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/showsnackbar.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tournament_client/widget/text.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  IO.Socket? socket;
  final TextEditingController controllerName = TextEditingController(text: '');
  final TextEditingController controllerNumber =
      TextEditingController(text: '');
  final TextEditingController controllerPoint =
      TextEditingController(text: '0');
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData() async {
    // Fetch and update your data from the server here
    // final updatedData = await service_api.listRanking();
    setState(() {
      // Assuming `model` is a state variable
    });
  }

  @override
  void initState() {
    debugPrint('INIT ADMINPAGE');
    super.initState();
    socket = IO.io('http://localhost:8090', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket!.onConnect((_) {
      print('Connected to server APP2');
    });
    socket!.onDisconnect((_) {
      print('Disconnected server from adminpage');
    });
    socket!.emit('eventFromClient2_force');
  }

  @override
  void dispose() {
    super.dispose();
    socket!.dispose();
  }

  void emitEvent() {
    socket!.emit('eventFromClient2_force');
    socket!.emit('eventFromClient_force');
  }

  final service_api = ServiceAPIs();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('add');
            openAlertDialog(
                function: () {
                  service_api
                      .createRanking(
                          // customer_name: 'test',customer_number: '234',point:'234',
                          customer_name: controllerName.text,
                          customer_number: controllerNumber.text,
                          point: controllerPoint.text)
                      .then((value) {
                    showSnackBar(context: context, message: value['message']);
                    setState(() {});

                    if (value['status'] == true) {
                      print('run it');
                      // sendEventFromClient2();
                    }
                  }).whenComplete(() {
                    setState(() {
                      controllerName.text = '';
                      controllerNumber.text = '';
                      controllerPoint.text = '0';
                    });

                    Navigator.of(context).pop();
                  });
                },
                service_api: service_api,
                context: context,
                controllerName: controllerName,
                controllerNumber: controllerNumber,
                controllerPoint: controllerPoint);
          },
          child: const Icon(
            Icons.add,
          )),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          width: width,
          height: height,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'asset/bg3.jpg',
                ),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        print('reset all for the 1st round');
                        service_api
                            .deleteRankingAllAndAddDefault()
                            .whenComplete(() => null);
                      },
                      child: textcustom(
                          text: 'RESET RANKING',
                          size: 14.0,
                          color: MyColor.black_text)),
                  ElevatedButton(
                      onPressed: () {
                        print('refresh to list');
                        setState(() {});
                      },
                      child: textcustom(
                          text: 'REFRESH LIST',
                          size: 14.0,
                          color: MyColor.black_text)),
                  ElevatedButton(
                      onPressed: () {
                        print('refresh to force update data');
                        socket!.emit('eventFromClient2_force');
                      },
                      child: textcustom(
                          text: 'REFRESH TABLET',
                          size: 14.0,
                          color: MyColor.black_text)),
                  Image.asset('asset/image/logo_renew.png',
                      width: 65.0, height: 65.0),
                ],
              ),
              SizedBox(
                  height: height * 0.85,
                  width: width,
                  child: FutureBuilder(
                    future: service_api.listRanking(),
                    builder: (BuildContext context,
                        AsyncSnapshot<RankingModel?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('An error orcur ${snapshot.error}');
                      }

                      final model = snapshot.data;
                      if (model!.data == null) {
                        return const Text('no data');
                      }
                      return RefreshIndicator(
                        key: refreshKey,
                        onRefresh: _refreshData,
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: model.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10.0),
                              decoration: BoxDecoration(
                                  color: MyColor.white,
                                  border: Border.all(
                                      color: MyColor.yellow_accent, width: .5),
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: ListTile(
                                leading: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          print('update $index');
                                          openAlertDialogUpdate(
                                              service_api: service_api,
                                              function: () {
                                                service_api
                                                    .updateRanking(
                                                        customer_name:
                                                            controllerName.text,
                                                        customer_number:
                                                            controllerNumber
                                                                .text,
                                                        point: controllerPoint
                                                            .text)
                                                    .then((value) {
                                                  showSnackBar(
                                                      context: context,
                                                      message:
                                                          value['message']);
                                                  refreshKey.currentState
                                                      ?.show();
                                                }).whenComplete(() {
                                                  controllerName.text == '';
                                                  controllerNumber.text == '';
                                                  controllerPoint.text == '';
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              context: context,
                                              valueName: model
                                                  .data![index].customerName,
                                              valueNumber: model
                                                  .data![index].customerNumber,
                                              valuePoint: model
                                                  .data![index].point
                                                  .toString(),
                                              controllerName: controllerName,
                                              controllerNumber:
                                                  controllerNumber,
                                              controllerPoint: controllerPoint);
                                        },
                                        icon: const Icon(Icons.update)),
                                    const SizedBox(width: 16.0),
                                    IconButton(
                                        onPressed: () {
                                          print(
                                              'delete $index ${model.data![index].customerName} ${model.data![index].customerNumber}');
                                          service_api
                                              .deleteRanking(
                                            customer_name:
                                                model.data![index].customerName,
                                            customer_number: model
                                                .data![index].customerNumber
                                                .toString(),
                                          )
                                              .then((value) {
                                            if (value['status'] == true) {
                                              // sendEventFromClient2();
                                            }
                                            showSnackBar(
                                                context: context,
                                                message: value['message']);
                                            setState(() {});
                                          }).whenComplete(() => null);
                                        },
                                        icon: const Icon(Icons.delete)),
                                  ],
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                style: ListTileStyle.drawer,
                                dense: true,
                                visualDensity:
                                    VisualDensity.adaptivePlatformDensity,
                                selectedColor: MyColor.white,
                                title: Text(
                                    'Customer Name: ${model.data![index].customerName}'),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Customer Number: ${model.data![index].customerNumber} '),
                                    Text('Point: ${model.data![index].point} '),
                                    Text(
                                        'Created Time: ${model.data![index].createdAt} '),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ))
            ],
          )),
    );
  }
}

// Widget openAlertDialog(
//     {controllerName, controllerNumber, controllerPoint, context}) {
//   return AlertDialog(
//     backgroundColor: Colors.white,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10.0), // Set border radius
//     ),
//     title: const Text('Player Setting'),
//     content: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         TextField(
//           controller: controllerName,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
//             hintText: 'Enter player name ',
//           ),
//         ),
//         TextField(
//           controller: controllerNumber,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
//             hintText: 'Enter player number ',
//           ),
//         ),
//         TextField(
//           controller: controllerPoint,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
//             hintText: 'Enter point ',
//           ),
//         ),
//       ],
//     ),
//     actions: [],
//   );
// }

void openAlertDialog(
    {TextEditingController? controllerName,
    TextEditingController? controllerNumber,
    TextEditingController? controllerPoint,
    BuildContext? context,
    function,
    ServiceAPIs? service_api}) {
  showDialog(
    context: context!,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: const Text('Add New Player '),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controllerName,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                hintText: 'Enter player name',
              ),
            ),
            TextField(
              controller: controllerNumber,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                hintText: 'Enter player number',
              ),
            ),
            TextField(
              controller: controllerPoint,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                hintText: 'Enter point',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (validateFields(
                  controllerName!, controllerNumber!, controllerPoint!)) {
                function();
              } else {
                showSnackBar(
                    context: context,
                    message: 'Please fill all input & point >0 ');
                // You can use a ScaffoldMessenger or other methods to display the error message.
              }
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}

bool validateFields(
    TextEditingController controllerName,
    TextEditingController controllerNumber,
    TextEditingController controllerPoint) {
  // Check if any of the text controllers is null or empty
  if (controllerName.text.isEmpty ||
      controllerNumber.text.isEmpty ||
      controllerPoint.text.isEmpty) {
    return false;
  }

  // Check if the "point" field has a value greater than 0
  if (double.tryParse(controllerPoint.text)! <= 0) {
    return false;
  }

  // All validation conditions are met
  return true;
}

void openAlertDialogUpdate(
    {TextEditingController? controllerName,
    TextEditingController? controllerNumber,
    TextEditingController? controllerPoint,
    BuildContext? context,
    String? valueName,
    function,
    String? valueNumber,
    String? valuePoint,
    ServiceAPIs? service_api}) {
  // Set default values for the text fields
  controllerName?.text = "$valueName"; // Set your default name
  controllerNumber?.text = "$valueNumber"; // Set your default number
  controllerPoint?.text = "$valuePoint"; // Set your default number
  showDialog(
    context: context!,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: const Text('Update  Player '),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              enabled: true,
              controller: controllerName,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                hintText: 'Enter player name',
              ),
            ),
            TextField(
              enabled: false,
              controller: controllerNumber,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                hintText: 'Enter player number',
              ),
            ),
            TextField(
              controller: controllerPoint,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                hintText: 'Enter point',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (validateFields(
                  controllerName!, controllerNumber!, controllerPoint!)) {
                function();
              } else {
                showSnackBar(
                    context: context,
                    message: 'Please fill different point value ');
                // You can use a ScaffoldMessenger or other methods to display the error message.
              }
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}
