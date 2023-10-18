import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tournament_client/containerpage.dart';
import 'package:tournament_client/welcome.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tournament',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: false,
          fontFamily: GoogleFonts.lato().fontFamily,
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        // home: MyHomePage2(title: 'text',),
        // home: BarCharRace(),
        // home: MyHomePage(title: 'homepage',selectedIndex: 2,),
        // home: const MyHomePage2(title: 'Tournament Client'),
        // home: MyHomePage(
        //     url: "http://localhost:8090",
        //     title: 'Tournament Client',
        //     selectedIndex: 10
        //     // selectedIndex: 1111111
        // )
        // home:const ExamplePage(),
        home: ContainerPage(url: 'http://localhost:8090',selectedIndex: 5,),
        // home: MyHomePageMongo(
        //           url: "http://localhost:8090",
        //           title: 'Tournament Client',
        //           selectedIndex: 5),
        // home:const TournamentPage()
        // home:WelcomePage()
        );
  }
}
