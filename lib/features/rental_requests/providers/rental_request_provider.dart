/*
 * lib/features/rental_requests/providers/rental_request_provider.dart
 *
 * Envio, aceite e recusa de solicitações de aluguel.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 12/10/2026
 */

import 'dart:developer';

import 'package:agroshare/features/profile/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_ui/material_ui.dart';

class RentalRequestProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendRentalRequest({
    CollectionReference<Map<String, dynamic>>? collection,
    UserModel? user,
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
      log('Error in rental_request_provider.dart');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
