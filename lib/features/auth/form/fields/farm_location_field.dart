//  farm_location_field.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 26/09/2026
//

import 'package:agroshare/features/auth/form/fields/credential_field.dart';
import 'package:flutter/widgets.dart';

class FarmLocationField with ChangeNotifier implements CredentialField {
  String? _msgError;
  String? _location;

  @override
  String? get msgError => _msgError;

  @override
  String? get getValue => _location;

  @override
  void validate(String? name) {
    if (name == null) {
      _msgError = 'Informe o município e o estado da propriedade.';
      notifyListeners();
      throw Exception(_msgError);
    }

    final List<String> words = name.trim().split(RegExp(r'\s+'));
    if (words.length < 2) {
      _msgError = 'Informe Município e Estado (Petrolina - PE).';
      notifyListeners();
      throw Exception(_msgError);
    }

    _location = name;
    _msgError = null;
    notifyListeners();
  }
}
