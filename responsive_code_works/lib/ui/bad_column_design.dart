import 'package:flutter/material.dart';
import 'package:responsive_code_works/ui/context_extension.dart';

class BadColDesign extends StatelessWidget {
  const BadColDesign({
    Key key,
    @required this.buildBottomNavBar,
    @required this.sampleChairUrl,
  }) : super(key: key);

  final BottomNavigationBar buildBottomNavBar;
  final String sampleChairUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: buildBottomNavBar,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              child: Center(
                child: Image.network(sampleChairUrl),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.black26,
                ),
                SizedBox(
                  width: 4,
                ),
                CircleAvatar(
                  radius: 5,
                ),
                SizedBox(
                  width: 4,
                ),
                CircleAvatar(
                  radius: 5,
                ),
                SizedBox(
                  width: 4,
                ),
                CircleAvatar(
                  radius: 5,
                ),
                SizedBox(
                  width: 4,
                ),
                CircleAvatar(
                  radius: 5,
                ),
              ],
            ),
            Container(
                child: Text(
              'Accent',
              style: TextStyle(fontSize: 45),
            )),
            Container(
              child: Text(
                'data ' * 24,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              height: 50,
            ),
            Container(
              height: 20,
            ),
            Container(height: 50, child: Placeholder()),
            Row(
              children: [
                IconButton(icon: Icon(Icons.favorite), onPressed: () {})
              ],
            )
          ],
        ),
      ),
    );
  }
}
