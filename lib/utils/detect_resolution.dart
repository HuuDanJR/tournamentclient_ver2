import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mystring.dart';

//input will be the length of list
double detectResolutionHeight(input) {
  final spacing = (10 * MyString.DEFAULT_SPACING_LING) / input;
  double height = ((40 * 10 + 34 * 10) - (spacing * 10)) / input;
  if (input <= 10) {
    debugPrint('<=10');
    return MyString.DEFAULT_HEIGHT_LINE;
  } else if (input > 10 && input <= 15) {
    debugPrint('height 10->15: $height');
    return height;
  } else if (input > 15 && input <= 20) {
    debugPrint('height 15->20: $height');
    return height;
  } else {
    debugPrint('height: >20: $height');
    //will set up a specific rule for height
    return height;
  }
}

double? detectResolutionSpacing(input) {
  final spacing = ((10 * MyString.DEFAULT_SPACING_LING)) / input;
  if (input <= 10) {
    debugPrint('spacing <=10');
    return MyString.DEFAULT_SPACING_LING;
  } else {
    debugPrint('spacing >10 $spacing');
    return spacing;
  }
}





double detectSpacingHeight({input, isSpacing, isHeight}) {
  if (isSpacing == true && isHeight == false) {
    final result = (40 * 34 * 10) / (input * 40);
    debugPrint('spacing: $result');
    return result;
  } else if (isSpacing == false && isHeight == true) {
    final spacing = (40 * 34 * 10) / (input * 40);
    final result = (40 * 34 * 10) / (input * spacing);
    debugPrint('height: $result');
    return result;
  } else {
    return MyString.DEFAULT_HEIGHT_LINE;
  }
}
