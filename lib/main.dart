import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tournament_client/admin_verify.dart';
import 'package:tournament_client/adminpage.dart';
import 'package:tournament_client/containerpage.dart';
import 'package:tournament_client/setuppage.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/welcome.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tournament',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          useMaterial3: false,
          fontFamily: GoogleFonts.lato().fontFamily,
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),


        routes: {
          '/containerPage': (context) => ContainerPage(url: MyString.BASEURL, selectedIndex: MyString.DEFAULTNUMBER,),
        },

        // home: MyHomePage2(title: 'text',),
        // home: BarCharRace(),
        // home: MyHomePage(title: 'homepage',selectedIndex: 2,),
        // home: const MyHomePage2(title: 'Tournament Client'),
        // home: MyHomePage(
        //     url: "http://localhost:8090",
        //     title: 'Tournament Client',
        //     selectedIndex: 10
        //     // selectedIndex: MyS
        // )
        // home:const ExamplePage(),
        // home: ContainerPage(url: 'http://localhost:8090',selectedIndex: 1,),
        
        // home: MyHomePageMongo(
        //           url: "http://localhost:8090",
        //           title: 'Tournament Client',
        //           selectedIndex: 5),
        // home:const TournamentPage()
        // home:const SetupPage()
        home: const AdminVerify()
        // home:const AdminPage()
        // home:WelcomePage()
        // home: ContainerPage(url: 'http://localhost:8090',selectedIndex: MyString.DEFAULTNUMBER,),
        );
  }
}
