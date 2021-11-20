import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_using/counter_bloc/counter_event.dart';
import 'package:flutter_cubit_using/counter_bloc/counter_state.dart';

import 'counter_bloc/counter_bloc.dart';

class BlocUsingPage extends StatefulWidget {
  const BlocUsingPage({Key? key}) : super(key: key);

  @override
  _BlocUsingPageState createState() => _BlocUsingPageState();
}

class _BlocUsingPageState extends State<BlocUsingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Package Using'),
      ),
      body: MyCenterWidget(),
      floatingActionButton: MyActions(),
    );
  }
}

class MyCenterWidget extends StatelessWidget {
  const MyCenterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('Main build');
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(' Count:'),
        BlocBuilder<CounterBloc, CounterState>(builder: (context, state) {
          log('Text builder');
          return Text(
            '${state.count}',
            style: const TextStyle(fontSize: 40),
          );
        }),
      ],
    ));
  }
}

class MyActions extends StatelessWidget {
  const MyActions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: '1',
          onPressed: () {
            context.read<CounterBloc>().add(CounterIncrease());
          },
          child: const Icon(Icons.add),
        ),
        FloatingActionButton(
          heroTag: '1',
          onPressed: () {
            context.read<CounterBloc>().add(CounterDecrease());
          },
          child: const Icon(Icons.remove),
        ),
      ],
    );
  }
}
