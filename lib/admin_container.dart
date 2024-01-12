import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tournament_client/adminpage.dart';
import 'package:tournament_client/setuppage.dart';

class AdminContainer extends StatelessWidget {
  const AdminContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon:null,text: "TOP RANKING",),
                Tab(icon: null,text: "REAL TIME RANKING",),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AdminPage(),
              SetupPage()
            ],
          ),
        ),
      ),);
  }
}
