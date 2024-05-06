import 'package:get/get.dart';

class Capitalize {
  final String? letter;
  final List<String>? letters;
  final TypeCapitalize? type;
  final List<TypeCapitalize>? types;

  Capitalize({
    this.letter,
    this.letters,
    this.type,
    this.types,
  });

  Capitalize.one({
    required this.letter,
    required this.type,
  })  : letters = null,
        types = null;

  Capitalize.all({
    required this.letters,
    required this.types,
  })  : letter = null,
        type = null;

  capitalize() {
    if (letters != null) {
      List<String> lettersFinal = [];
      for (var i = 0; i < types!.length; i++) {
        if (types![i] == TypeCapitalize.capital) {
          lettersFinal.add(letters![i].capitalize!);
        } else {
          lettersFinal.add(letters![i].toUpperCase());
        }
      }
      return lettersFinal;
    } else {
      if (type == TypeCapitalize.capital) {
        return letter!.capitalize;
      } else {
        return letter!.toUpperCase();
      }
    }
  }
}

enum TypeCapitalize {
  capital,
  uppercase,
}
