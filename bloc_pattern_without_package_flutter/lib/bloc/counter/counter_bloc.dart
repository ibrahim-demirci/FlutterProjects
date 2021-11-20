import 'dart:async';

import 'package:repository_pattern_with_bloc/bloc/counter/counter_event.dart';

class CounterBloc {
  int _count = 0;

  // StreamController for state
  final _counterStateStreamController = StreamController<int>();
  Stream<int> get counter => _counterStateStreamController.stream;
  StreamSink<int> get _counterStateSink => _counterStateStreamController.sink;

  // StreamController for events
  final _counterEventStreamController = StreamController<CounterEvent>();
  Stream<CounterEvent> get _counterEventStream => _counterEventStreamController.stream;
  StreamSink<CounterEvent> get counterEventSink => _counterEventStreamController.sink;

  CounterBloc() {
    _counterEventStream.listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent event) {
    if (event is IncreaseEvent) {
      _count++;
    } else {
      _count--;
    }
    _counterStateSink.add(_count);
  }
}
