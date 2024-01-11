import 'package:flutter/material.dart';
import 'package:tournament_client/lib/bar_chart_race.dart';
import 'package:tournament_client/utils/mycolors.dart';

Widget barcharcustom(data) {
  return BarChartRace(
    data: data,
    index: 1,
    rectangleHeight: 45,
    selectedIndex: 1,
    initialPlayState: true,
    columnsColor: const [
      Color(0xFFFF9900),
      MyColor.blue_coinbase,
      Color(0xFFA2AAAD),
      MyColor.red,
      Color(0xFF212326),
      MyColor.bedge,
      MyColor.pinkMain,
      MyColor.green_araconda,
      MyColor.red_accent,
      MyColor.yellow_accent,
    ],
    framesPerSecond: 60,
    framesBetweenTwoStates: 30,
    spaceBetweenTwoRectangles: 22,
    offset_text: 3.5,
    offset_title: 3.5,
    numberOfRactanglesToShow: 10,
    title: "RANKING TOURNAMENT",
    columnsLabel: const [
      "Amazon",
      "Google",
      "Apple",
      "Coca",
      "Huawei",
      "Sony",
      'Pepsi',
      "Samsung",
      "Netflix",
      "Facebook",
    ],
    statesLabel: List.generate(
      30,
      (index) => formatDate(
        DateTime.now().add(
          Duration(days: index),
        ),
      ),
    ),
    
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 24,
    ),
  );
}

formatDate(DateTime date) {
  int day = date.day;
  int month = date.month;
  int year = date.year;
  return "";
  // return "Vegas Club - Caravelle";
  // return "${months[month - 1]} $day, $year";
}

List<String> months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

List<String> weekDays = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
];
