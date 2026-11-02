/*
 * lib/features/equipment/form/equipment_edit_form.dart
 *
 * Formulário de edição de preço, período e status do equipamento.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 23/10/2026
 */

import 'package:material_ui/material_ui.dart';

class EquipmentEditForm with ChangeNotifier {
  String? newPrice;
  String? newPeriodic;
  bool? _newStatus;

  bool? get newStatus => _newStatus;

  void change(bool? status) {
    _newStatus = status;
    notifyListeners();
  }

  bool get isNotEmpty => (newPeriodic != null) || (newPrice != null);

  void clearData() {
    newPrice = null;
    newPeriodic = null;
    _newStatus = null;
    notifyListeners();
  }
}
