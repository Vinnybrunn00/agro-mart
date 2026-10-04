import 'dart:developer';

import 'package:agroshare/core/streams/user_stream.dart';
import 'package:agroshare/models/equipamentos/equipamentos_model.dart';
import 'package:agroshare/repository/users/users_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  DocumentReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users').doc(_currentUser?.uid);

  CollectionReference<Map<String, dynamic>> get _items =>
      _firestore.collection('equipamentos');

  int get timeStamp => DateTime.now().millisecondsSinceEpoch;

  Future<void> saveProduct(EquipamentosModel product) async {
    final DocumentSnapshot<Map<String, dynamic>> getUser = await _users.get();

    final UsersRepository usersRepository = UsersRepository.fromQueryDocument(
      queryDocument: getUser,
    );

    await _items.doc().set({
      'uid': usersRepository.id,
      'name': usersRepository.name,
      'price': _convertForCent(product.price!),
      'timestamp': timeStamp,
      'nome_equipamento': product.name,
      'description': product.description,
      'lat': usersRepository.latitude,
      'long': usersRepository.longitude,
    });
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
