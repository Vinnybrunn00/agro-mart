import 'package:agroshare/core/constants/regex_patterns.dart';
import 'package:agroshare/features/auth/form/fields/credential_field.dart';
import 'package:flutter/widgets.dart';

class CpfField with ChangeNotifier implements CredentialField {
  String? _cpf;
  String? _msgError;

  @override
  String? get getValue => _cpf;

  @override
  String? get msgError => _msgError;

  @override
  void validate(String? cpf) {
    final String digits = cpf!.replaceAll(nonDigits, '');

    if (digits.isEmpty) {
      _msgError = 'O CPF não pode estar vazio';
      notifyListeners();
      throw Exception(_msgError);
    }

    if (digits.length != 11) {
      _msgError = 'O CPF deve conter 11 dígitos.';
      notifyListeners();
      throw Exception(_msgError);
    }

    if (allSameDigit.hasMatch(digits)) {
      _msgError = 'CPF inválido.';
      notifyListeners();
      throw Exception(_msgError);
    }

    if (!_hasValidCheckDigits(digits)) {
      _msgError = 'CPF inválido.';
      notifyListeners();
      throw Exception(_msgError);
    }

    _cpf = cpf;
    _msgError = null;
    notifyListeners();
  }

  bool _hasValidCheckDigits(String digits) {
    final List<int> numbers = digits.split('').map(int.parse).toList();

    for (final int position in [9, 10]) {
      int sum = 0;
      for (int i = 0; i < position; i++) {
        sum += numbers[i] * (position + 1 - i);
      }

      int checkDigit = (sum * 10) % 11;
      if (checkDigit == 10) checkDigit = 0;

      if (checkDigit != numbers[position]) return false;
    }

    return true;
  }
}
