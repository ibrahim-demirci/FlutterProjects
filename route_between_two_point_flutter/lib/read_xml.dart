import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

class KMLReader {
  Future<List<List<String>>> readKML({String path}) async {
    List<dynamic> coordinateList;
    String kmlText;
    

    kmlText = await loadAsset(path);
    log(kmlText);

    var root = XmlDocument.parse(kmlText)
        .getElement('Document')
        .getElement('Placemark')
        .getElement('LineString')
        .getElement('coordinates');

    //log(root.text);

    if (root == null) {
      print('Element alınamadı');
      return null;
    } else {
      // print("Original Text ---");
      // print(root.text);

      // print("Split by ''  Text ---");
      // coordinateList = root.text.split(' ');
      // print(coordinateList);

      LineSplitter ls = new LineSplitter();
      List<String> lines = ls.convert(root.text);
      List<List<String>> coordinateList = [];

      // print("---Result---");
      // for (var i = 0; i < lines.length; i++) {
      //   print('Line $i: ${lines[i]}');
      // }

      //print("-- split lines by '' ---- \n\n");
      for (var i = 0; i < lines.length - 1; i++) {
        List<String> coordinate = lines[i].trim().split(',');
        coordinateList.add(coordinate);
      }

      return coordinateList;
      //print('Coordinate list' + coordinateList.toString());
    }
    //log(coordinateList.toString());
  }

  Future<String> loadAsset(String assetPath) async {
    return await rootBundle.loadString(assetPath);
  }
}

//
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:xml/xml.dart';
//
// void main() async {
//   String kmlText;
//   List<dynamic> coordinateList;
//
//   kmlText = await loadAsset('assets/path.kml');
//
//   var root = XmlDocument.parse(kmlText)
//       .getElement('Document')
//       .getElement('Placemark')
//       .getElement('LineString')
//       .getElement('coordinates');
//   if (root == null) {
//     print('Element alınamadı');
//     return null;
//   } else {
//     // print("Original Text ---");
//     // print(root.text);
//
//     // print("Split by ''  Text ---");
//     // coordinateList = root.text.split(' ');
//     // print(coordinateList);
//
//     LineSplitter ls = new LineSplitter();
//     List<String> lines = ls.convert(root.text);
//     List<List<String>> coordinateList = [];
//
//     // print("---Result---");
//     // for (var i = 0; i < lines.length; i++) {
//     //   print('Line $i: ${lines[i]}');
//     // }
//
//     print("-- split lines by '' ---- \n\n");
//     for (var i = 0; i < lines.length - 1; i++) {
//       List<String> coordinate = lines[i].trim().split(',');
//       coordinateList.add(coordinate);
//     }
//
//     print('Coordinate list' + coordinateList.toString());
//   }
// }
//
// Future<String> loadAsset(String assetPath) async {
//
//     return await rootBundle.loadString(assetPath);
//   }


/*
import 'dart:io';
import 'dart:convert';
import 'dart:async';

void main() async {
  final file = File('path.kml');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  try {
    await for (var line in lines) {
      print('$line: ${line.length} characters');
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }
}
*/
