main() {

  try{
    araFonksiyon(1000);
  }
  catch (e){
    print('main fonksiyonu şu hatayı yakaladı $e');
  }

}

// Bunu da API fonksiyonu gibi düşünebilriz.
void function_1(int num) {
  if (num < 100)
    print(num);
  else
    throw Exception('Bilinmeyen bir hata oluştu');
}

// Bunu bir servis fonksiyonu gibi düşünebiliriz.
void araFonksiyon(int num) {


  try {
    function_1(num);
  }catch (e){
    print('Ara fonksiyon şu hatayı yakaladı: $e');
    rethrow;
  }
}


class ExceptionTypeA implements Exception {}

class ExceptionTypeB implements Exception {}

// 1. network fail
// 2. authentication fail


// rethrow.