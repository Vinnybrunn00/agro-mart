/*
 * lib/features/auth/form/fields/cpf_field.dart
 *
 * Campo de CPF do cadastro e sua validação.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 05/09/2026 - Updated on 06/11/2026
 */

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

    if (!_validateCpf(digits)) {
      _msgError = 'CPF inválido.';
      notifyListeners();
      throw Exception(_msgError);
    }

    _cpf = cpf;
    _msgError = null;
    notifyListeners();
  }

  static String _completeCpf(String partialCpf) {
    if (partialCpf.length == 11) return partialCpf;

    int sum = 0;

    for (int weight = partialCpf.length + 1; weight >= 2; weight--) {
      final int? digit = int.tryParse(
        partialCpf[partialCpf.length + 1 - weight],
      );

      if (digit != null) {
        sum += digit * weight;
      }
    }

    final int rawCheckDigit = 11 - (sum % 11);
    final int checkDigit = rawCheckDigit > 9 ? 0 : rawCheckDigit;
    final String extendedCpf = '$partialCpf$checkDigit';
    return _completeCpf(extendedCpf);
  }

  static bool _validateCpf(String cpf) =>
      _completeCpf(cpf.substring(0, cpf.length - 2)) == cpf;
}
