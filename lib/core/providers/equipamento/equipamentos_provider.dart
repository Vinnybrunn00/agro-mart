import 'package:flutter/material.dart';

class EditEquipamento with ChangeNotifier {
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
