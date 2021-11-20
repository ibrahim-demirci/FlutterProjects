import 'dart:async';
import 'package:emre_altunbilek_state_mng/bloc/counter/counter_event.dart';

class CounterBloc {
  int _sayac = 0;

  // StreamController for state - output value
  final _counterStateStreamController = StreamController<int>();

  Stream<int> get getCounter => _counterStateStreamController.stream;
  StreamSink<int> get _getCounterStateSink => _counterStateStreamController.sink;

  // StreamController for event - enter value
  final _counterEventStreamController = StreamController<CounterEvent>();

  Stream<CounterEvent> get _getCounterEventStream => _counterEventStreamController.stream;
  StreamSink<CounterEvent> get getCounterEventSink => _counterEventStreamController.sink;




  CounterBloc() {

    // StateController'a veri geldiğinde  tetiklenecek.
    _getCounterEventStream.listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent event) {


    if (event is IncreaseEvent) {

      _sayac++;

    }
    else {
      _sayac--;

    }
    _getCounterStateSink.add(_sayac);
  }
}
