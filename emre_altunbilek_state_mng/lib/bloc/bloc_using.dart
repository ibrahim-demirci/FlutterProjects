import 'dart:async';

import 'package:emre_altunbilek_state_mng/bloc/counter/counter_bloc.dart';
import 'package:emre_altunbilek_state_mng/bloc/counter/counter_event.dart';
import 'package:flutter/material.dart';

class BlocUsing extends StatefulWidget {
  @override
  _BlocUsingState createState() => _BlocUsingState();
}

class _BlocUsingState extends State<BlocUsing> {
  final _counterBloc = CounterBloc();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bloc Pattern Stream'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your have pushed the button this many time:',
            ),
            StreamBuilder<int>(
              initialData: 0,
              stream: _counterBloc.getCounter,
              builder: (context, snapshot) {
                return Text(
                  snapshot.data.toString(),
                  style: TextStyle(fontSize: 30),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _counterBloc.getCounterEventSink.add(IncreaseEvent());
            },
            child: Icon(Icons.add),
            heroTag: '1',
          ),
          FloatingActionButton(
            onPressed: () {

              _counterBloc.getCounterEventSink.add(DecreaseEvent());

            },
            child: Icon(Icons.remove),
            heroTag: '2',
          ),
        ],
      ),
    );
  }
}
