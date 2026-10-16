//
// ferramentas_services.dart
// AgroShare
//
//  Create by Vinícius Bruno on 12/10/2026.
//

import 'dart:developer';

import 'package:agroshare/repository/users/users_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FerramentasServices with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendRequestEquipamento({
    CollectionReference<Map<String, dynamic>>? collection,
    UsersRepository? user,
  }) async {
    try {
      _setLoading(true);

      await collection?.doc(user?.id).set({
        'id': user?.id,
        'name': user?.name,
        'photo': user?.photo,
        'nameProperty': user?.nameProperty,
        'accept': false,
      });
    } catch (erro) {
      log('Error in ferramentas_services.dart');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
