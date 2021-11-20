import 'package:flutter/material.dart';
import 'package:responsive_code_works/ui/context_extension.dart';

class ColumnDesignView extends StatefulWidget {
  @override
  _ColumnDesignViewState createState() => _ColumnDesignViewState();
}

class _ColumnDesignViewState extends State<ColumnDesignView> {
  final sampleChairUrl =
      'https://i.pinimg.com/originals/7b/7a/e6/7b7ae6371c1adcee2ff88de3d51e09b6.png';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      bottomNavigationBar: buildBottomNavBar,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 20, child: Center(child: Image.network(sampleChairUrl))),
            Expanded(child: buildRowImageButtons()),
            Expanded(
                flex: 3,
                child: FittedBox(
                    child: Text('Accent',
                        style: Theme.of(context).textTheme.headline3))),
            Expanded(
                flex: 6,
                child: Text('data' * 24,
                    style: Theme.of(context).textTheme.headline6)),
            Spacer(),
            Expanded(flex: 2, child: Placeholder()),
            Expanded(flex: 3, child: buildRowBuyButtons())
          ],
        ),
      ),
    );
  }

  Row buildRowImageButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: Colors.black26,
        ),
        CircleAvatar(
          radius: 5,
        ),
        CircleAvatar(
          radius: 5,
        ),
        CircleAvatar(
          radius: 5,
        ),
        CircleAvatar(
          radius: 5,
        ),
      ],
    );
  }

  Row buildRowBuyButtons() {
    return Row(
      children: [
        Expanded(
            child: IconButton(icon: Icon(Icons.favorite), onPressed: () {})),
        Spacer(
          flex: 5,
        ),
        Expanded(flex: 4, child: ElevatedButton(onPressed: null, child: null)),
        Spacer(),
        Expanded(flex: 4, child: ElevatedButton(onPressed: null, child: null)),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Hello"),
    );
  }

  BottomNavigationBar get buildBottomNavBar {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.hail), label: 'Page 1'),
        BottomNavigationBarItem(icon: Icon(Icons.hail), label: 'Page 2 '),
      ],
    );
  }
}
