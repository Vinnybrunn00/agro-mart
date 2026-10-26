import 'package:agroshare/core/constants/regex_patterns.dart';
import 'package:agroshare/features/auth/form/fields/credential_field.dart';
import 'package:flutter/widgets.dart';

class PasswordField with ChangeNotifier implements CredentialField {
  String? _password;
  String? _msgError;

  @override
  String? get getValue => _password;

  @override
  String? get msgError => _msgError;

  @override
  void validate(String? password) {
    if (password == null) {
      _msgError = 'A senha não pode estar vazia';
      notifyListeners();
      throw Exception(_msgError);
    }

    if (password.length <= 10) {
      _msgError = 'Senha muito curta, tenta uma senha mais longa';
      notifyListeners();
      throw Exception(_msgError);
    }

    if (hasSpace.hasMatch(password)) {
      _msgError = 'A senha não pode conter espaços.';
      notifyListeners();
      throw Exception(_msgError);
    }

    final Map<bool, String> rules = {
      hasCharacter.hasMatch(password):
          r'A senha deve conter pelo menos um caractere especial. [@#$%^&*]',
      hasLowerCase.hasMatch(password):
          'A senha deve conter pelo menos uma letra minúscula',
      hasUpperCase.hasMatch(password):
          'A senha deve conter pelo menos uma letra maiúscula',
      hasNumbers.hasMatch(password): 'A senha deve conter números.',
    };

    for (final MapEntry<bool, String> rule in rules.entries) {
      if (!rule.key) {
        _msgError = rule.value;
        notifyListeners();
        throw Exception(_msgError);
      }
    }

    _password = password;
    _msgError = null;
    notifyListeners();
  }
}
