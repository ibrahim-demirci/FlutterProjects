import 'package:flutter/material.dart';
import 'package:responsive_code_works/ui/context_extension.dart';

class ListViewDesing extends StatefulWidget {
  ListViewDesing({Key key}) : super(key: key);

  @override
  _ListViewDesingState createState() => _ListViewDesingState();
}

class _ListViewDesingState extends State<ListViewDesing> {
  final sampleImageUrl =
      'https://i0.wp.com/www.pngmart.com/files/7/Folding-Chair-PNG-File.png';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMyAppBar(),
      body: ListView(
        shrinkWrap: true,
        children: [
          Text('Explore', style: context.theme.textTheme.headline4),
          SizedBox(height: context.dynamicHeight(0.2), child: buildChairRow()),
          context.emptyWidget,
          context.emptyWidget,
          AspectRatio(aspectRatio: 10 / 1, child: buildCategoriesHorizontal()),
          gridViewChairs()
        ],
      ),
    );
  }

  AppBar buildMyAppBar() =>
      AppBar(backgroundColor: Colors.transparent, elevation: 0);

  Row buildChairRow() {
    return Row(
      children: [
        Expanded(child: buildCardItem()),
        Expanded(child: buildCardItem()),
        Expanded(child: buildCardItem()),
      ],
    );
  }

  ListView buildCategoriesHorizontal() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30,
        itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Data "),
            ));
  }

  GridView gridViewChairs() {
    return GridView.builder(
      itemCount: 20,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1, mainAxisSpacing: 10, crossAxisCount: 2),
      itemBuilder: (context, index) =>
          ChairsCard(sampleImageUrl: sampleImageUrl),
    );
  }

  Card buildCardItem() {
    return Card(
        child: ListTile(
      title: Image.network(sampleImageUrl),
      subtitle: Text('Sample Text'),
    ));
  }
}

class ChairsCard extends StatelessWidget {
  const ChairsCard({
    Key key,
    @required this.sampleImageUrl,
  }) : super(key: key);

  final String sampleImageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: ListTile(
        title: Image.network(sampleImageUrl),
        subtitle: Text('Data'),
      ),
    );
  }
}
