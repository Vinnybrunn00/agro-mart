//  current_anuncio_provider.dart
//  AgroMart
//
//  Create by Vinicius Bruno on 12/10/2026
//

import 'dart:developer';

import 'package:agroshare/core/providers/equipamento/equipamentos_provider.dart';
import 'package:agroshare/repository/equipamento/equipamento_repository.dart';
import 'package:flutter/material.dart';

class CurrentAnuncioProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Essa função altera o status do equipamento.
  Future<void> updateStatus(
    EquipamentoRepository equipamento,
    EditEquipamento editEquip,
  ) async {
    try {
      _setLoading(true);

      if (equipamento.equipamentoReference != null) {
        await equipamento.equipamentoReference?.update({
          'status': editEquip.newStatus,
        });
      }
    } catch (err) {
      log('Error in current_anuncio_provider.dart');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePrice(
    EquipamentoRepository equipamento,
    EditEquipamento editEquip,
  ) async {
    try {
      _setLoading(true);

      if (equipamento.equipamentoReference != null) {
        await equipamento.equipamentoReference?.update({
          'price': _convertForCent(editEquip.newPrice!),
        });
      }
    } catch (err) {
      log('Error in current_anuncio_provider.dart');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePeriodic(
    EquipamentoRepository equipamento,
    EditEquipamento editEquip,
  ) async {
    try {
      _setLoading(true);

      if (equipamento.equipamentoReference != null) {
        await equipamento.equipamentoReference?.update({
          'periodo_dias': editEquip.newPeriodic,
        });
      }
    } catch (erro) {
      log('Error in current_anuncio_provider.dart');
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
