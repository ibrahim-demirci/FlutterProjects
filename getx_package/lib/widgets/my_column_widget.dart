import 'package:flutter/material.dart';
import 'package:getx_package/controller/counter_controller.dart';
import 'package:getxfire/getxfire.dart';

class MyColumn extends StatelessWidget {
  // This code below find the Controller on widget tree.
  CounterController _findController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GetX<CounterController>(
          builder: (_controller2) => Text(
            ' ${_controller2.count} ' + 'button_text'.tr + ' (GetX)',
            style: TextStyle(fontSize: 32),
          ),
        ),
        Obx(
          () => Text(
            ' ${_findController.count} ' + 'button_text'.tr + ' (Obx)',
            style: TextStyle(fontSize: 32),
          ),
        ),
        Text(
          'hello'.tr, // For translate
          style: TextStyle(fontSize: 32),
        )
      ],
    );
  }
}
