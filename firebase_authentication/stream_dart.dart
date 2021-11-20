import 'dart:async';

main() {
  // Fonksiyon parantezlerle yazilirsa calistirilir
  /* myStreamFunction().listen(

      // Get value
      (event) {
    print(event);
  });

  */

  StreamController _myStreamController = StreamController();
  void functionForStreamController() async {
    for (int i = 0; i < 5; i++) {
      await Future.delayed(Duration(seconds: 1));

      // hata verdirmek
      if (i == 3) {
        _myStreamController.addError("Get an error ");
      }
      // Stream giris noktasi islemleri icim sink
      // Burda akisin basindan itibaren deger ekliyoruz
      _myStreamController.sink.add(i + 1);
    }

    _myStreamController.addError("Get an error ");
    // Akisin bittigini soyluyoruz
    _myStreamController.close();
  }

  // Fonksiyonu cagirdik
  functionForStreamController();

  _myStreamController.stream.listen(
    (event) {
      print(event * 10);
    },
    // Stream biterse
    onDone: () {
      print("Stream Listener done");
    },
    // Hata alinirsa
    onError: (error) {
      print(error);
    },
    // Hata durumunda exit
    cancelOnError: true,
  );
}

// StreamControlle olmadan yazmak.
// Bu artik cihazin hafizasinda var ne zaman çagirirsak dart isi ele alir
Stream<int> myStreamFunction() async* {
  for (int i = 0; i < 10; i++) {
    // Wait one seconds
    await Future.delayed(Duration(seconds: 1));

    // Not return ! yield
    yield i + 1;
  }
}
