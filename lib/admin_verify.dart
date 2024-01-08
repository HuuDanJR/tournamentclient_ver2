import 'package:flutter/material.dart';
import 'package:tournament_client/adminpage.dart';
import 'package:tournament_client/containerpage.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/setuppage.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/utils/showsnackbar.dart';
import 'package:tournament_client/widget/text.dart';
import "dart:html" as html;

class AdminVerify extends StatefulWidget {
  const AdminVerify({Key? key}) : super(key: key);

  @override
  State<AdminVerify> createState() => _AdminVerifyState();
}

class _AdminVerifyState extends State<AdminVerify> {
  final TextEditingController controllerName = TextEditingController(text: '');
  final TextEditingController controllerPass = TextEditingController(text: '');

  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  final service_api = ServiceAPIs();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        // Your scaffold content
        body: Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('asset/bg.jpg',),fit: BoxFit.cover,filterQuality: FilterQuality.low),
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Colors.black,
        //     Colors.black87,
        //     Colors.black54,
        //     Colors.black,
        //   ],
        //   stops: [
        //     0.0,
        //     0.35,
        //     0.75,
        //     0.95,
        //   ], // Adjust the stops to control the gradient effect
        // ),
      ),
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textcustom(text: 'LOGIN ADMIN', size: 18.0),
                IconButton(
                    onPressed: () {
                      html.window.location.reload();
                    },
                    icon: Icon(Icons.refresh, color: MyColor.red_accent))
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            const SizedBox(
              height: 24.0,
            ),
            TextFormField(
              enabled: true,
              controller: controllerName,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                suffix: Icon(Icons.person_2_outlined),
                fillColor: MyColor.white,
                focusColor: MyColor.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                hintText: 'Enter username',
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              enabled: true,
              obscureText: true,
              controller: controllerPass,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                suffix: Icon(Icons.password_outlined),
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                hintText: 'Enter password',
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
                onPressed: () {
                  if (validateFields(
                        controllerName,
                        controllerPass,
                      ) ==
                      true) {
                    if (controllerName.text == 'admin' &&
                        controllerPass.text == 'vegas123') {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AdminPage(),
                      ));
                    } else {
                      showSnackBar(
                          context: context,
                          message:
                              'Password or username not correct, please try again');
                    }
                  } else {
                    showSnackBar(
                        context: context,
                        message: 'Please fill  password or username');
                    // You can use a ScaffoldMessenger or other methods to display the error message.
                  }
                },
                child: textcustom(text: "SUBMIT")),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ContainerPage(
                                url: MyString.BASEURL,
                                selectedIndex: MyString.DEFAULTNUMBER,
                              )));
                    },
                    child: textcustom(text: "WEB CLIENT")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => SetupPage()));
                    },
                    child: textcustom(text: "SETUP")),
              ],
            )
          ],
        ),
      ),
    ));
  }

  void openLoginDialog(
      {TextEditingController? controllerName,
      TextEditingController? controllerPass,
      BuildContext? context,
      String? valueName,
      function,
      String? valueNumber,
      String? valuePoint,
      ServiceAPIs? service_api}) {
    // Set default values for the text fields
    controllerName?.text = "$valueName"; // Set your default name
    controllerPass?.text = "$valueNumber"; // Set your default number
    showDialog(
      context: context!,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text('Login Page Admin '),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                enabled: false,
                controller: controllerName,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  hintText: 'Enter username',
                ),
              ),
              TextField(
                enabled: false,
                controller: controllerPass,
                // keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  hintText: 'Enter password',
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
                      controllerName!,
                      controllerPass!,
                    ) ==
                    true) {
                  print('oke');
                } else {
                  showSnackBar(
                      context: context,
                      message: 'Please fill correct password or username');
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
}

bool validateFields(TextEditingController controllerName,
    TextEditingController controllerPass) {
  // Check if any of the text controllers is null or empty
  if (controllerName.text.isEmpty || controllerPass.text.isEmpty) {
    return false;
  }

  // All validation conditions are met
  return true;
}
