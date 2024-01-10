import 'package:flutter/material.dart';

Widget mytextfield({hint,controller}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(hintText: "$hint"),
  );
}
