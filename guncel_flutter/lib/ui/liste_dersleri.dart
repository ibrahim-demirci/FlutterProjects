import 'dart:ui';

import 'package:flutter/material.dart';

class ListeKonuAnlatimi extends StatelessWidget {
  //liste icin veri kaynagi olustur

  List<int> listeNumaralari = List.generate(300, (index) => index);
  List<String> listeAltBaslik =
      List.generate(300, (index) => "Liste elemanı alt başlık $index");

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: listeNumaralari
          .map(
            (oankieleman) => Column(
              children: [
                Container(
                  child: Card(
                    color: Colors.teal.shade100,
                    margin: EdgeInsets.all(5),
                    elevation: 10,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.android),
                        radius: 12,
                      ),
                      title: Text("Liste elemanı başlık $oankieleman"),
                      subtitle: Text(listeAltBaslik[oankieleman]),
                      trailing: Icon(Icons.add_circle),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.orange,
                  height: 32,
                  indent: 20,
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

/**
    <Widget>[
    Column(
    children: [
    Container(
    child: Card(
    color: Colors.teal.shade100,
    margin: EdgeInsets.all(5),
    elevation: 10,
    child: ListTile(
    leading: CircleAvatar(
    child: Icon(Icons.android),
    radius: 12,
    ),
    title: Text("Liste elemanı başlık "),
    subtitle: Text("Liste elemanı altbaşlık "),
    trailing: Icon(Icons.add_circle),
    ),
    ),
    ),
    Divider(
    color: Colors.orange,
    height: 32,
    indent: 20,
    ),
    ],
    ),
    ],
 */
