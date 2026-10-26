import 'package:agroshare/features/equipment/form/fields/equipment_field.dart';
import 'package:flutter/widgets.dart';

class EquipmentDaysField with ChangeNotifier implements EquipmentField {
  String? _error;
  String? _days;

  @override
  String? get getValue => _days;

  @override
  String? get msgError => _error;

  @override
  void validate(String? days) {
    if (days == null || days.isEmpty) {
      _error = 'O período do equipamento não pode estar vazio.';
      notifyListeners();
      throw Exception(_error);
    }
    _days = days;
    _error = null;
    notifyListeners();
  }
}
