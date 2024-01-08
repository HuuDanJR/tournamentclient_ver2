import 'package:flutter/material.dart';

 // ignore: non_constant_identifier_names
 snackbar_custom({context,String? text,colorBG}){
  return ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            // closeIconColor: Colors.blueAccent,
            backgroundColor: Colors.white,
            // showCloseIcon: true,
            elevation: 2.0,
            dismissDirection: DismissDirection.up,
            duration:  const Duration(seconds: 1),
            content: Text('$text',style:const TextStyle(color:Colors.black)),
          ));
}