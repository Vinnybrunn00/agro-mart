import 'package:agroshare/models/equipamentos/contract.dart';
import 'package:flutter/widgets.dart';

class PriceEquipamento with ChangeNotifier implements InfoEquipamentos {
  String? _error;
  String? _price;

  @override
  String? get getValue => _price;

  @override
  String? get msgError => _error;

  @override
  void validate(String? price) {
    if (price == null || price.isEmpty) {
      _error = 'O preço do equipamento não pode estar vazio.';
      notifyListeners();
      throw Exception(_error);
    }
    _price = price;
    _error = null;
    notifyListeners();
  }
}
