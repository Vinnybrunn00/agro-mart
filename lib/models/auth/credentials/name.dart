//  name.dart
//  AgroMart
//
//  Create by Vinicius Bruno on 05/09/2026
//

import 'package:agroshare/constants/regex.dart';
import 'package:agroshare/models/auth/credentials/contract/credentials_contract.dart';
import 'package:flutter/widgets.dart';

class Name with ChangeNotifier implements Credentials {
  String? _msgError;
  String? _name;

  @override
  String? get msgError => _msgError;

  @override
  String? get getValue => _name;

  @override
  void validate(String? name) {
    if (name == null) {
      _msgError = 'O nome completo não pode estar vazio';
      notifyListeners();
      throw Exception(_msgError);
    }

    if (hasNumbers.hasMatch(name)) {
      _msgError = 'O nome não pode conter números.';
      notifyListeners();
      throw Exception(_msgError);
    }

    final List<String> words = name.trim().split(RegExp(r'\s+'));
    if (words.length < 2) {
      _msgError = 'Informe seu nome completo (nome e sobrenome).';
      notifyListeners();
      throw Exception(_msgError);
    }

    _name = name;
    _msgError = null;
    notifyListeners();
  }
}
