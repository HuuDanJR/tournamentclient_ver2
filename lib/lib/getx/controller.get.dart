import 'package:get/get.dart';

class MyGetXController extends GetxController {


  RxInt playerNumber = 1.obs;

  savePlayerNumber(number) {
    playerNumber.value = number;
  }

  resetPlayerNumber() {
    playerNumber.value = 1;
  }
}
