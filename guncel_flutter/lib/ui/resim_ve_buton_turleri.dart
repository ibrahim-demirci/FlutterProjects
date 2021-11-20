import 'package:flutter/material.dart';



class ResimveButonTurleri extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Text(
          "Resim ve Buton Türleri",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(4),
                  width: 100,
                  height: 100,
                  color: Colors.red.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset("asset/images/indir.jpeg"),
                      Text("Asset Image"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(4),
                  width: 100,
                  height: 100,
                  color: Colors.red.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Image.network(
                            "https://pbs.twimg.com/profile_images/1299397507844157440/qFI17wvQ_400x400.jpg"),
                      ),
                      Text("Netwrok Image"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(4),
                  width: 100,
                  height: 100,
                  color: Colors.red.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://pbs.twimg.com/profile_images/1213557288256057345/17nVT6TQ_400x400.jpg"),
                        radius: 35,
                      ),
                      Text("Circle Avatar"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(4),
                  color: Colors.red.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FadeInImage.assetNetwork(
                          placeholder: "asset/images/loading.gif",
                          image:
                          "https://pbs.twimg.com/profile_images/1299397507844157440/qFI17wvQ_400x400.jpg"),
                      Text("FadeIn Image"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(4),
                  color: Colors.red.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlutterLogo(
                        size: 60,
                        colors: Colors.lightBlue,
                        style: FlutterLogoStyle.stacked,
                        textColor: Colors.black,
                      ),
                      Text("Flutter Logo"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(4),
                  color: Colors.red.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Placeholder(
                          color: Colors.black38,
                          strokeWidth: 6.0,
                        ),
                      ),
                      Text("PlaceHolder Widged"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                onPressed: () => debugPrint("Fat arrowlu fonksiyon"),
                child: Text("Emre Altunbilek"),
                color: Colors.orange,
                textColor: Colors.white,
              ),
              RaisedButton(
                onPressed: () {
                  debugPrint("normal lambda fonksiyon");
                  debugPrint("ikinci satir ");
                },
                child: Text("Flutter ve Dart Dersleri"),
                color: Colors.purple,
                textColor: Colors.white,
              ),
              RaisedButton(
                onPressed: uzunMethod,
                child: Text("Hızla Devam Ediyor"),
                color: Colors.red,
                textColor: Colors.white,
              ),
              IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => {},
                iconSize: 60,
                color: Colors.green.shade800,
              ),
              FlatButton(
                onPressed: () => {},
                child: Text(
                  "FlatButton",
                  style: TextStyle(fontSize: 25),
                ),
                textColor: Colors.blue.shade800,
              ),
            ],
          ),
        )
      ],
    );
  }
}

void uzunMethod() {
  debugPrint("uzun ayrı fonksiyon");
}