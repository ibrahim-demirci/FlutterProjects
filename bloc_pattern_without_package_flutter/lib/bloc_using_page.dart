import 'package:flutter/material.dart';
import 'package:repository_pattern_with_bloc/bloc/counter/counter_event.dart';

import 'bloc/counter/counter_bloc.dart';

class BlocUsingPage extends StatefulWidget {
  const BlocUsingPage({Key? key}) : super(key: key);

  @override
  _BlocUsingPageState createState() => _BlocUsingPageState();
}

class _BlocUsingPageState extends State<BlocUsingPage> {
  final _counterBloc = CounterBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Using'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Text('You have pushed button this many times:'),
            StreamBuilder<int>(
              initialData: 0,
              stream: _counterBloc.counter,
              builder: (context, snapshot) => Text(
                '${snapshot.data}',
                style: const TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: '1',
            child: const Icon(Icons.add),
            onPressed: () {
              _counterBloc.counterEventSink.add(IncreaseEvent());
            },
          ),
          FloatingActionButton(
            heroTag: '2',
            child: const Icon(Icons.remove),
            onPressed: () {
              _counterBloc.counterEventSink.add(DecreaseEvent());
            },
          ),
        ],
      ),
    );
  }
}
