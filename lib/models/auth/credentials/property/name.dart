//  name.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 26/09/2026
//

import 'package:agroshare/models/auth/credentials/contract/credentials_contract.dart';
import 'package:flutter/widgets.dart';

class NameProperty with ChangeNotifier implements Credentials {
  String? _msgError;
  String? _name;

  @override
  String? get msgError => _msgError;

  @override
  String? get getValue => _name;

  @override
  void validate(String? name) {
    if (name == null) {
      _msgError = 'O nome da propriedade não pode estar vazio';
      notifyListeners();
      throw Exception(_msgError);
    }

    if (name.isEmpty) {
      _msgError = 'O nome da propriedade não pode estar vazio';
      notifyListeners();
      throw Exception(_msgError);
    }

    _name = name;
    _msgError = null;
    notifyListeners();
  }
}
