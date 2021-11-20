import 'dart:async';

import 'package:flutter/material.dart';

class StreamUsing extends StatefulWidget {
  @override
  _StreamUsingState createState() => _StreamUsingState();
}

class _StreamUsingState extends State<StreamUsing> {


  final StreamController<int> _streamController = StreamController<int>();
  int _counter = 0;

  @override
  void dispose() {
    // Bittiğinde controlleri kapat.
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream Kullanımı'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your have pushed the button this many time:',
            ),
            StreamBuilder(
                initialData: 0,

                // controller pizza house
                // enter values sink
                // exit values stream
                stream: _streamController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot){

              if(!snapshot.hasError){

                if(snapshot.hasData){

                  return Text(
                    snapshot.data.toString(),
                    style: Theme.of(context).textTheme.display1,
                  );
                }
                else{
                  return SizedBox();
                }
              }else{
                return SizedBox();
              }
            })
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _streamController.sink.add(++_counter);
            },
            child: Icon(Icons.add),
            heroTag: '1',
          ),
          FloatingActionButton(
            onPressed: () {
                _streamController.sink.add(--_counter);
            },
            child: Icon(Icons.remove),
            heroTag: '2',
          ),
        ],
      ),
    );
  }
}

