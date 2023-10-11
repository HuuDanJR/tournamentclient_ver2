library bar_chart_race;

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:tournament_client/lib/getx/controller.get.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'dart:math' as math;
import 'models/rectangle.dart';
import 'paint/my_state_paint.dart';

/// Creates an interactive bar chart depending on the provided [data], which looks like a race
///
/// [data] should be a matrix of double with at least two columns and two rows, and stores data in cumulative way
/// [initialPlayState] if true then the bar chart will be animated, else it will show the first row of data and stop
/// [framesPerSecond] defines the number of frames to show per seconds
/// [columnsLabel] represents the name of the columns
/// [statesLabel] represents the name of the rows (usually time)
/// [numberOfRactanglesToShow] represents the number of the first columns to show
/// [title] title of the bar chart race
/// [columnsColor] the color of each column
class BarChartRace extends StatefulWidget {
  /// each row represents a state and each column represents one instance
  /// data should contains at least two rows and two columns, else it's not logic
  /// data should be cumulative
  final List<List<double>> data;

  /// if it's true then the bar chart will be animated
  final bool initialPlayState;

  /// number of frame to show in one second
  final double framesPerSecond;

  /// represent the number of frames to show between two states (two consecutive rows)
  final int framesBetweenTwoStates;

  /// a list of labels for each column.
  /// length of the this list show be equals to the number of columns of [data].
  ///
  /// for examle if you are going to study countries provides the list of countries with the same order as the columns in data.
  final List<String> columnsLabel;

  /// one label for each state.
  /// if your state is the time you need to prodive the time of each state
  /// length of [stateLabels] list should be equal to the number of rows in [data].
  final List<String> statesLabel;

  /// number of rectangles to show in the UI.
  ///
  /// For example if you are studying ten countries, you can show the first five countries only
  /// by default it equals to the number of columns in the data
  final int numberOfRactanglesToShow;

  /// a color for each column,
  ///
  /// for example if you are studying countries, you can assign to each country a color
  /// colors should be ordred as the column in the [data]
  /// by default it uses random colors
  final List<Color>? columnsColor;

  /// represent the title of the chart
  final String title;

  /// the styling for the text
  final TextStyle titleTextStyle;

  /// the height of the rectangle
  final double rectangleHeight;
  final int? index;
  final int? selectedIndex;

  const BarChartRace({
    Key? key,
    required this.data,
    required this.selectedIndex,
     this.index,
    required this.initialPlayState,
    this.framesPerSecond = 20,
    this.framesBetweenTwoStates = 40,
    this.rectangleHeight = 45,
    this.numberOfRactanglesToShow = 5,
    required this.columnsLabel,
    required this.statesLabel,
    this.columnsColor,
    required this.title,
    required this.titleTextStyle,
  }) : super(key: key);

  @override
  _BarChartRaceState createState() => _BarChartRaceState();
}

class _BarChartRaceState extends State<BarChartRace> {
  int? nbStates;
  int? nbParticipants;
  // data of preprocessing the initial data
  List<List<Rectangle>>? preparedData;
  // current data to show
  List<Rectangle>? currentData;

  //addtion from Dan
  TextEditingController? controller = TextEditingController();
  final controllerGetX = Get.put(MyGetXController());

  @override
  void initState() {
    // init local variables`
    nbStates = widget.data.length;
    nbParticipants = widget.data[0].length;
    // prepare data to be shown in the customPainer
    preparedData = prepareData(widget.data);
    currentData = preparedData![0];
    if (widget.initialPlayState) play();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BarChartRace oldWidget) {
    if (oldWidget.data != widget.data) {
      print('did update widget run ');
      // Update the preparedData and currentData based on the new widget.data
      preparedData = prepareData(widget.data);
      // currentData = preparedData![0];
      if (widget.initialPlayState) play();
    }
    super.didUpdateWidget(oldWidget);
  }

  // re-build
  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body:
      Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [
              //     Colors.black,
              //     Colors.black87,
              //   ],
              //   stops: [
              //     0.0,
              //     0.75,
              //   ], // Adjust the stops to control the gradient effect
              // ),
              image: DecorationImage(
                filterQuality: FilterQuality.low,
                image: AssetImage('asset/image/210912_rotate.jpeg'),
                fit: BoxFit.cover, // Make the image cover the entire container
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 84,
              vertical: 84,
            ),
            child: LayoutBuilder(
              builder: (_, constraints) => CustomPaint(
                painter: MyStatePaint(
                  index: widget.index,
                  currentState: currentData!,
                  numberOfRactanglesToShow: widget.numberOfRactanglesToShow,
                  // rectHeight: widget.rectangleHeight,
                  rectHeight: 42.5,
                  maxValue: currentData![0].maxValue,
                  totalWidth: constraints.maxWidth * .9,
                  title: widget.title,
                  titleTextStyle: widget.titleTextStyle,
                  maxLength: null,
                ),
              ),
            ),
          ),
      
      //  Stack(
      //   alignment: Alignment.center,
      //   children: [
      //     // Positioned(
      //     //     top: 12,
      //     //     right: 12,
      //     //     child: GestureDetector(
      //     //         onTap: () {
      //     //           showDialog(
      //     //             context: context,
      //     //             builder: (BuildContext context) {
      //     //               return AlertDialog(
      //     //                 backgroundColor: Colors.white,
      //     //                 shape: RoundedRectangleBorder(
      //     //                   borderRadius: BorderRadius.circular(
      //     //                       10.0), // Set border radius
      //     //                 ),
      //     //                 title: Text('Player Setting'),
      //     //                 content: TextField(
      //     //                   controller: controller,
      //     //                   keyboardType: TextInputType.number,
      //     //                   decoration: const InputDecoration(
      //     //                     contentPadding:
      //     //                         const EdgeInsets.symmetric(horizontal: 4.0),
      //     //                     hintText: 'Enter player number ( 1-10 )',
      //     //                   ),
      //     //                 ),
      //     //                 actions: [
      //     //                   TextButton(
      //     //                     onPressed: () {
      //     //                       if (controller!.text.isNum) {
      //     //                         if (int.tryParse(controller!.text) != null) {
      //     //                           int number = int.parse(controller!.text);
      //     //                           if (number >= 1 && number <= 10) {
      //     //                             // The text is a valid number within the range 1-10
      //     //                             controllerGetX.savePlayerNumber(number);
      //     //                           }
      //     //                         }
      //     //                       }
      //     //                       Navigator.of(context).pop();
      //     //                     },
      //     //                     child: Text('Confirm'),
      //     //                   ),
      //     //                   TextButton(
      //     //                     onPressed: () {
      //     //                       Navigator.of(context).pop(); // Close the dialog
      //     //                     },
      //     //                     child: Text('Close'),
      //     //                   ),
      //     //                 ],
      //     //               );
      //     //             },
      //     //           );
      //     //         },
      //     //         child: Icon(
      //     //           Icons.settings_rounded,
      //     //           color: MyColor.grey,
      //     //           size: 34,
      //     //         ))),
      //     Container(
      //       height: height,
      //       width: width,
      //       decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //           begin: Alignment.topCenter,
      //           end: Alignment.bottomCenter,
      //           colors: [
      //             Colors.black,
      //             Colors.black87,
      //           ],
      //           stops: [
      //             0.0,
      //             0.75,
      //           ], // Adjust the stops to control the gradient effect
      //         ),
      //         // image: DecorationImage(
      //         //   filterQuality: FilterQuality.low,
      //         //   image: AssetImage('asset/image/background.png'),
      //         //   fit: BoxFit.cover, // Make the image cover the entire container
      //         // ),
      //       ),
      //       padding: const EdgeInsets.symmetric(
      //         horizontal: 84,
      //         vertical: 84,
      //       ),
      //       child: LayoutBuilder(
      //         builder: (_, constraints) => CustomPaint(
      //           painter: MyStatePaint(
      //             index: widget.index,
      //             currentState: currentData!,
      //             numberOfRactanglesToShow: widget.numberOfRactanglesToShow,
      //             // rectHeight: widget.rectangleHeight,
      //             rectHeight: 42.5,
      //             maxValue: currentData![0].maxValue,
      //             totalWidth: constraints.maxWidth * .9,
      //             title: widget.title,
      //             titleTextStyle: widget.titleTextStyle,
      //             maxLength: null,
      //           ),
      //         ),
      //       ),
      //     ),
      //     Positioned(
      //         bottom: 24,
      //         right: 24,
      //         child: Text('YOU ARE PLAYER ${widget.selectedIndex}',
      //             style: TextStyle(
      //               color: MyColor.white,
      //               fontSize: 24,
      //             )
      //             // GetBuilder<MyGetXController>(
      //             //   builder: (controller) =>
      //             //       Text('YOU ARE PLAYER ${controller.playerNumber.value}',
      //             //           style: TextStyle(
      //             //             color: MyColor.black_text,
      //             //             fontSize: 24,
      //             //           )),
      //             )),
      //     Positioned(
      //         top: 12,
      //         left: 12,
      //         child: Container(
      //           alignment: Alignment.center,
      //           width: 135,
      //           height: 55,
      //           decoration: BoxDecoration(
      //               image: DecorationImage(
      //                   image: AssetImage('asset/image/logo_new.png'),
      //                   fit: BoxFit.contain)),
      //         )),
      //   ],
      // ),
    );
  }

  void play() async {
    for (int i = 1; i < nbStates!; i++) {
      await makeTransition(preparedData![i - 1], preparedData![i]);
    }
  }

  Future<void> makeTransition(
      List<Rectangle> before, List<Rectangle> after) async {
    int nbFrames = widget.framesBetweenTwoStates;
    int fps = widget.framesBetweenTwoStates;

    for (int k = 1; k <= nbFrames; k++) {
      // for each frame we update the current value
      for (int i = 0; i < nbParticipants!; i++) {
        // get the difference between two states
        double posDiff = (after[i].position - before[i].position) / nbFrames;
        double lengthDiff = (after[i].length - before[i].length) / nbFrames;
        double valueDiff = (after[i].value - before[i].value) / nbFrames;
        double maxValueDiff =
            (after[i].maxValue - before[i].maxValue) / nbFrames;
        // add the new differences
        currentData![i].length = before[i].length + lengthDiff * k;
        currentData![i].position = before[i].position + posDiff * k;
        currentData![i].value = before[i].value + valueDiff * k;
        currentData![i].maxValue = before[i].maxValue + maxValueDiff * k;
        // upadte the labels
        if ((widget.columnsLabel.length ?? 0) > 0) {
          currentData![i].label = widget.columnsLabel[i];
        }
        if ((widget.statesLabel.length ?? 0) > 0) {
          currentData![i].stateLabel = before[i].stateLabel;
        }
      }
      // rebuild the UI
      _update();
      await Future.delayed(Duration(milliseconds: 2000 ~/ fps));
    }
  }

  // prepare data so that it can be shown,
  List<List<Rectangle>> prepareData(List<List<double>> data) {
    List<List<Rectangle>> resultData = [];
    // for each state (a row from data), we sort row without modifying by using anothe list of indexes
    for (int i = 0; i < nbStates!; i++) {
      List<int> indexes = List.generate(nbParticipants!, (index) => index);
      // sort the indexes in deceasing order based on the data in the row
      indexes.sort((int a, int b) {
        return data[i][b].compareTo(data[i][a]);
      });
      // get the max value, which is in the first index
      double maxValue = data[i][indexes[0]];
      // List<Rectangle> currentState = List(nbParticipants);
      List<Rectangle> currentState = List<Rectangle>.filled(
        nbParticipants ?? 0,
        Rectangle(
          maxValue: 0, // Provide appropriate values here
          length: 0,
          position: 0,
          value: 0,
          color: MyColor.blue,
          stateLabel: '',
          label: '',
        ),
      );
// currentState[widget.index] = Rectangle(
//           maxValue: maxValue,
//           length: data[i][widget.index] / maxValue,
//           position: 1.0 * widget.index,
//           value: data[i][widget.index],
//           color: widget.columnsColor == null
//               ? Colors.green
//               : widget.columnsColor![widget.index],
//           stateLabel: widget.statesLabel[i],
//           label: widget.columnsLabel[widget.index],
//         );
      for (int j = 0; j < nbParticipants!; j++) {
        int index = indexes[j];
        // generate a random color to use in case the colors are not provided
        Color randomColor =
            Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1);
        // create the Rectable object which will be used to draw the chart
        currentState[index] = Rectangle(
          maxValue: maxValue,
          length: data[i][index] / maxValue,
          position: 1.0 * j,
          value: data[i][index],
          color: widget.columnsColor == null
              ? index != widget.index
                  ? MyColor.orang3
                  : MyColor.green_araconda
              : widget.columnsColor![index],
          stateLabel: widget.statesLabel[i],
          label: widget.columnsLabel[index],
        );
      }
      resultData.add(currentState);
    }
    return resultData;
  }
}
