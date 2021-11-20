import 'package:flutter/material.dart';
import 'package:getx_package/controller/counter_controller.dart';
import 'package:get/get.dart';
import 'package:getx_package/pages/page2.dart';
import 'package:getx_package/translation.dart';

import 'widgets/my_column_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Messages(),
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
      title: 'Material App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // This code is add controller to FULL WIDGET TREE.
  final CounterController _controller = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    print('Stateless build worked');
    return Scaffold(
      floatingActionButton: buildFAbButtons(),
      body: Center(
        child: MyColumn(),
      ),
    );
  }

  Column buildFAbButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: '1',
          onPressed: () {
            _controller.increase();

            // Bottom snackbar
            Get.showSnackbar(GetBar(
              title: 'Default SnackBar',
              message: 'Arttırıldı',
              isDismissible: true,
            ));

            print(_controller.count);
          },
          child: Icon(Icons.add),
        ),
        FloatingActionButton(
          heroTag: '2',
          onPressed: () {
            _controller.decrease();

            // Top snackbar awesome :)
            Get.snackbar(
              'SnackBar',
              'Azaltıldı',
              backgroundColor: Colors.teal,
            );
            print(_controller.count);
          },
          child: Icon(Icons.remove),
        ),
        FloatingActionButton(
          heroTag: '3',
          onPressed: () {
            Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
          },
          child: Icon(Icons.track_changes),
        ),
        FloatingActionButton(
          heroTag: '4',
          onPressed: () {
            //This means Navigator.push()
            Get.to(Page2());

            //This means Navigator.replacement()
            // Get.off(Page2());
          },
          child: Icon(Icons.arrow_right_outlined),
        ),
        FloatingActionButton(
          heroTag: '5',
          onPressed: () {
            Get.updateLocale(
              Get.locale == Locale('tr', 'TR') ? Locale('en', 'US') : Locale('tr', 'TR'),
            );
          },
          child: Icon(Icons.language),
        ),
      ],
    );
  }
}
