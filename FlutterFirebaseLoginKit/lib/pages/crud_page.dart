import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:flutterx_firebaselogin/constants/constants.dart';

class FireStoreCrud extends StatefulWidget {
  @override
  _FireStoreCrudState createState() => _FireStoreCrudState();
}

class _FireStoreCrudState extends State<FireStoreCrud> {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      color: Colors.black54,
      elevation: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${doc.data['name']}',
              style: TextStyle(fontSize: 24,color: Colors.white),
            ),
            Text(
              'Message: ${doc.data['message']}',
              style: TextStyle(fontSize: 15,color: Colors.white),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  onPressed: () => updateData(doc),
                  child: Text('Update', style: TextStyle(color: Colors.white)),
                  color: Colors.blueAccent.withOpacity(0.6),
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => deleteData(doc),
                  child: Text('Delete',style: TextStyle(color: Colors.white)),
                  color: Colors.redAccent.withOpacity(0.6),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: kBoxDecorationStyle,
      height: 60.0,
      child: TextFormField(
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left:20.0),
          hintText: 'Name',
          hintStyle: kHintTextStyle,
        ),
        validator: (value) =>
        value.isEmpty ? 'Please Enter some text' : null,
        onSaved: (value) => name = value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Center(
              child: new Image.asset('assets/images/bg.jpg',
                  width: size.width,
                  height: size.height,
                  fit: BoxFit.fill,
                  color: Color.fromRGBO(50, 50, 50, 0.9),
                  colorBlendMode: BlendMode.modulate),
            ),
            SizedBox(
              height: 80.0,
            ),
            Container(
              width: size.width,
              height: size.height,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 50.0,
                ),
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag:'crud',
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Icon(
                          Icons.border_color,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'CRUD',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Form(
                      key: _formKey,
                      child: buildTextFormField(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: createData,
                          child: Text('Create', style: TextStyle(color: Colors.white)),
                          color: Colors.green,
                        ),
                        RaisedButton(
                          onPressed: id != null ? readData : null,
                          child: Text('Read', style: TextStyle(color: Colors.white)),
                          color: Colors.lightBlue,
                        ),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: db.collection('CRUD').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(children: snapshot.data.documents.map((doc) => buildItem(doc)).toList());
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('CRUD').add({'name': '$name', 'message': randomMessage()});
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('CRUD').document(id).get();
    print(snapshot.data['name']);
  }

  void updateData(DocumentSnapshot doc) async {
    await db.collection('CRUD').document(doc.documentID).updateData({'message': randomMessage()});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('CRUD').document(doc.documentID).delete();
    setState(() => id = null);
  }

  String randomMessage() {
    final randomNumber = Random().nextInt(4);
    String message;
    switch (randomNumber) {
      case 1:
        message = 'Thank you!';
        break;
      case 2:
        message = 'You\'re Welcome!';
        break;
      case 3:
        message = 'Thanks for using our App';
        break;
      default:
        message = 'Visit www.codesolutions101.com';
        break;
    }
    return message;
  }
}

