import 'package:flutter/material.dart';
import 'package:tournament_client/home.dart';
import 'package:tournament_client/home_mongo.dart';

class ContainerPage extends StatefulWidget {
  const ContainerPage({super.key});

  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //list from mongo
            SizedBox(
              width: width / 2,
              height: height,
              child: MyHomePageMongo(
                  url: "http://localhost:8090",
                  title: 'Tournament Client',
                  selectedIndex: 5),
            ),
            SizedBox(
              width: width / 2,
              height: height,
              child: MyHomePage(
                  url: "http://localhost:8090",
                  title: 'Tournament Client',
                  selectedIndex: 5),
            )
            //list realtime
          ],
        ),
      ),
    );
  }
}
