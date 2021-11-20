import 'package:get/get.dart';

class CounterController extends GetxController {
  // This value have .obs beacuse this can change.
  var _count = 0.obs;

  int get count => _count.value;
  set count(int value) => _count.value = value;

  void increase() {
    // Set and get using the blow.
    count = count + 1;
  }

  void decrease() {
    // Set and get using the blow.
    count = count - 1;
  }
}
