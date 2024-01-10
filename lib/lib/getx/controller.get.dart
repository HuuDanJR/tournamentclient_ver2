import 'package:get/get.dart';

class MyGetXController extends GetxController {
  RxInt playerNumber = 1.obs;
  //will set in default 10
  RxInt totalRow = 10.obs;

  savePlayerNumber(number) {
    playerNumber.value = number;
  }

  resetPlayerNumber() {
    playerNumber.value = 1;
  }

  saveTotalRow(number) {
    totalRow.value = number;
    print('saveTotalRow : ${totalRow.value}');
    update();
  }

  resetTotalRow() {
    totalRow.value = 10;
  }
}
