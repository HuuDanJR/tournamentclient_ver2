import 'package:flutter/material.dart';

Widget loadingIndicator(text) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const CircularProgressIndicator(),
        const SizedBox(height: 16), // Adjust the height as needed
        Text('$text'),
      ],
    ),
  );
}
