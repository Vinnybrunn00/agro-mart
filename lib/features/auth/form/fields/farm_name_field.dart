/*
 * lib/features/auth/form/fields/farm_name_field.dart
 *
 * Campo de nome da propriedade e sua validação.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 26/09/2026
 */

import 'package:agroshare/features/auth/form/fields/credential_field.dart';
import 'package:flutter/widgets.dart';

class FarmNameField with ChangeNotifier implements CredentialField {
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
