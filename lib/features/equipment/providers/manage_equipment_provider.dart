//  manage_equipment_provider.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 12/10/2026
//

import 'dart:developer';

import 'package:agroshare/features/equipment/form/equipment_edit_form.dart';
import 'package:agroshare/features/equipment/models/equipment_model.dart';
import 'package:flutter/material.dart';

class ManageEquipmentProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Essa função altera o status do equipamento.
  Future<void> updateStatus(
    EquipmentModel equipamento,
    EquipmentEditForm editEquip,
  ) async {
    try {
      _setLoading(true);

      if (equipamento.equipamentoReference != null) {
        await equipamento.equipamentoReference?.update({
          'status': editEquip.newStatus,
        });
      }
    } catch (err) {
      log('Error in manage_equipment_provider.dart');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePrice(
    EquipmentModel equipamento,
    EquipmentEditForm editEquip,
  ) async {
    try {
      _setLoading(true);

      if (equipamento.equipamentoReference != null) {
        await equipamento.equipamentoReference?.update({
          'price': _convertForCent(editEquip.newPrice!),
        });
      }
    } catch (err) {
      log('Error in manage_equipment_provider.dart');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePeriodic(
    EquipmentModel equipamento,
    EquipmentEditForm editEquip,
  ) async {
    try {
      _setLoading(true);

      if (equipamento.equipamentoReference != null) {
        await equipamento.equipamentoReference?.update({
          'periodo_dias': editEquip.newPeriodic,
        });
      }
    } catch (erro) {
      log('Error in manage_equipment_provider.dart');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int _convertForCent(String formatText) {
    if (formatText.isNotEmpty) {
      String onlyDigit = formatText.replaceAll(RegExp(r'[^\d]'), '');

      if (onlyDigit.isEmpty) return 0;

      return int.parse(onlyDigit);
    }
    return 0;
  }
}
