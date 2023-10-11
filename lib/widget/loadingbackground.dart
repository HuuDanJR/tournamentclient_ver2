import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tournament_client/widget/loading_indicator.dart';

Widget loadingbackground({Future<LottieComposition>? composition, width, height}) {
  return FutureBuilder<LottieComposition>(
    future: composition,
    builder: (context, snapshot) {
      var composition = snapshot.data;
      if (composition != null) {
        return Lottie(
            repeat: true,
            fit: BoxFit.fitWidth,
            width: width,
            height: height,
            composition: composition);
      } else {
        return loadingIndicator('loading background');
      }
    },
  );
}
