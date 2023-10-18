import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mycolors.dart';

Widget loadingIndicator(text) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const CircularProgressIndicator(
          strokeWidth: .5,
          color: MyColor.white,
        ),
        const SizedBox(height: 16), // Adjust the height as needed
        Text('$text',style:const TextStyle(color:MyColor.white)),
      ],
    ),
  );
}
