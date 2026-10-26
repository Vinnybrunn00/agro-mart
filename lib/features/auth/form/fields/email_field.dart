import 'package:agroshare/core/constants/regex_patterns.dart';
import 'package:agroshare/features/auth/form/fields/credential_field.dart';
import 'package:flutter/widgets.dart';

class EmailField with ChangeNotifier implements CredentialField {
  String? _email;
  String? _msgError;

  @override
  String? get getValue => _email;

  @override
  String? get msgError => _msgError;

  @override
  void validate(String? email) {
    if (email == null) {
      _msgError = 'O email não pode estar vazio';
      notifyListeners();
      throw Exception(_msgError);
    }

    if (hasSpace.hasMatch(email)) {
      _msgError = 'O email não pode conter espaços.';
      notifyListeners();
      throw Exception(_msgError);
    }

    if (!isValidEmail.hasMatch(email)) {
      _msgError = 'Informe um endereço de email válido.';
      notifyListeners();
      throw Exception(_msgError);
    }

    _email = email;
    _msgError = null;
    notifyListeners();
  }
}
