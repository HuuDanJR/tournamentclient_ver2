import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mystring.dart';

//HEIGHT
double detectResolutionHeight({input}) {
  final spacing = (MyString.DEFAULT_ROW * MyString.DEFAULT_SPACING_LING) / input;
  final double height = ((MyString.DEFAULT_HEIGHT_LINE * MyString.DEFAULT_ROW + MyString.DEFAULT_SPACING_LING * MyString.DEFAULT_ROW) - (spacing * MyString.DEFAULT_ROW)) / input;
  final double height_big = ((MyString.DEFAULT_HEIGHT_LINE * MyString.DEFAULT_ROW + MyString.DEFAULT_SPACING_LING * MyString.DEFAULT_ROW) - (spacing * MyString.DEFAULT_ROW)) / input;
  if (input < 5 ) {
    final value =MyString.DEFAULT_HEIGHT_LINE*1.5;
    debugPrint('height <5: ${value}');
    return value;
  } 
  else if (input <= 10) {
    final value =height_big+(spacing)-MyString.DEFAULT_SPACING_LING;
    debugPrint('height <=10: ${value}');
    return value;
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


//SPACING
double? detectResolutionSpacing({input}) {
  final spacing = ((MyString.DEFAULT_ROW * MyString.DEFAULT_SPACING_LING)) / input;
  if (input <= 10) {
    debugPrint('spacing <=10 ${MyString.DEFAULT_SPACING_LING}');
    return MyString.DEFAULT_SPACING_LING;
  } else {
    debugPrint('spacing >10 $spacing');
    return spacing;
  }
}


//OFFSET
double? detectResolutionOffsetX({input}){
  double offsetX = (MyString.DEFAULT_OFFSETX_TEXT/input) * MyString.DEFAULT_ROW;
  if (input <= 10) {
    debugPrint('offsetX <=10 ${MyString.DEFAULT_OFFSETX_TEXT+offsetX}');
    return MyString.DEFAULT_OFFSETX_TEXT+offsetX;
  } else if (input > 10 && input <= 15) {
    debugPrint('offsetX 10->15: $offsetX');
    return offsetX;
  } else if (input > 15 && input <= 20) {
    debugPrint('offsetX 15->20: $offsetX');
    return offsetX;
  } else {
    debugPrint('offsetX: >20: $offsetX');
    //will set up a specific rule for height
    return offsetX;
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
