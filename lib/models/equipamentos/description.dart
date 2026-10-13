import 'package:agroshare/models/equipamentos/contract.dart';
import 'package:flutter/widgets.dart';

class DescriptionEquipamento with ChangeNotifier implements InfoEquipamentos {
  String? _error;
  String? _description;

  @override
  String? get getValue => _description;

  @override
  String? get msgError => _error;

  @override
  void validate(String? description) {
    if (description == null || description.isEmpty) {
      _error = 'A descrição do equipamento não pode estar vazia.';
      notifyListeners();
      throw Exception(_error);
    }

    if (description.length <= 10) {
      _error = 'A descrição precisa ter pelo menos 11 caracteres';
      notifyListeners();
      throw Exception(_error);
    }

    _description = description;
    _error = null;
    notifyListeners();
  }
}
