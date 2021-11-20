import 'package:get/get.dart';

class Messages extends Translations {
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello World',
          'button_text': 'times you click',
        },
        'tr_TR': {
          'hello': 'Selam Dünya',
          'button_text': 'kere tıkladınız',
        }
      };
}
