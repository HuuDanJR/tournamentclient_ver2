import 'package:flutter/material.dart';
import 'package:tournament_client/home.dart';
import 'package:tournament_client/utils/mycolors.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController controller = TextEditingController(text: '');
  final TextEditingController controllerUrl =
      TextEditingController(text: 'http://localhost:8090');
  bool isDialogVisible = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var checkboxValue = false;

  @override
  void initState() {
    super.initState();
    controllerUrl.text = 'http://localhost:8090';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.black87,
            ],
            stops: [
              0.0,
              0.75,
            ], // Adjust the stops to control the gradient effect
          ),
          // image: DecorationImage(
          //   filterQuality: FilterQuality.low,
          //   image: AssetImage('asset/image/background.png'),
          //   fit: BoxFit.cover, // Make the image cover the entire container
          // ),
        ),
        child: Stack(
          children: [
            Positioned(
                top: 12,
                left: 12,
                child: Container(
                  alignment: Alignment.center,
                  width: 135,
                  height: 55,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/image/logo_new.png'),
                          fit: BoxFit.contain)),
                )),
            // MyHomePage(title: 'tournament page',selectedIndex: 0,),
            if (isDialogVisible)
              AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Set border radius
                ),
                title: const Text('Player Setting'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                        title: const Text("Member"),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: checkboxValue,
                        onChanged: (value) {
                          setState(() {
                            checkboxValue = value!;
                          });
                        }),
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 4.0),
                        hintText: 'Enter player number (1-10)',
                      ),
                    ),
                    TextField(
                      controller: controllerUrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 4.0),
                        hintText: 'Enter host',
                      ),
                    ),
                    
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if(checkboxValue==false){
                           Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => MyHomePage(
                                  url: controllerUrl.text,
                                  title: 'Tournament Client',
                                  selectedIndex:111111)));
                      }else
                      {
                        if (controller.text.isNotEmpty ) {
                        int? number = int.tryParse(controller.text);
                        if (number != null && number >= 1 && number <= 10) {
                          setState(() {
                            isDialogVisible = false; // Hide the dialog
                          });
                          final snackBar = SnackBar(
                              duration: const Duration(seconds: 1),
                              backgroundColor: MyColor.black_text,
                              content: Text(
                                'You chose as player ${controller.text}',
                                style: const TextStyle(
                                    fontFamily: 'OpenSan',
                                    fontSize: 16,
                                    color: MyColor.white),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          // The text is a valid number within the range 1-10
                          // Do something with the number here
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => MyHomePage(
                                  url: controllerUrl.text,
                                  title: 'Tournament Client',
                                  selectedIndex:int.parse(controller.text))));
                        } else {
                          const snackBar = SnackBar(
                              backgroundColor: MyColor.black_text,
                              content: Text(
                                'Please input number from 1-10',
                                style: TextStyle(
                                    fontFamily: 'OpenSan',
                                    fontSize: 16,
                                    color: MyColor.white),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                      }
                    },
                    child: const Text('Confirm'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isDialogVisible = false; // Hide the dialog
                      });
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

void showInSnackBar(String value, scaffoldKey) {
  scaffoldKey.currentState
      .showSnackBar(SnackBar(content: Text(value)));
}
