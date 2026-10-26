import 'package:agroshare/features/equipment/form/fields/equipment_field.dart';
import 'package:flutter/widgets.dart';

class EquipmentNameField with ChangeNotifier implements EquipmentField {
  String? _error;
  String? _name;

  @override
  String? get getValue => _name;

  @override
  String? get msgError => _error;

  @override
  void validate(String? name) {
    if (name == null || name.isEmpty) {
      _error = 'O nome do equipamento não pode estar vazio.';
      notifyListeners();
      throw Exception(_error);
    }

    if (name.length <= 5) {
      _error = 'O nome do equipamento deve ter pelo menos 6 caracteres.';
      notifyListeners();
      throw Exception(_error);
    }

    _name = name;
    _error = null;
    notifyListeners();
  }
}
