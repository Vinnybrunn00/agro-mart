import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

class EquipamentosModel with ChangeNotifier {
  String? name;
  String? price;
  String? description;

  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter.currency(
        locale: 'pt_BR',
        symbol: 'R\$',
        decimalDigits: 2,
      );

  CurrencyTextInputFormatter get formatter => _formatter;
}
