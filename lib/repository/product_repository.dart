import 'dart:developer';
import 'dart:io';

import 'package:agroshare/models/equipamentos/equipamentos_model.dart';
import 'package:agroshare/repository/users/users_repository.dart';
import 'package:agroshare/services/picker/select_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class ProductRepository with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  int get timeStamp => DateTime.now().millisecondsSinceEpoch;

  DocumentReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users').doc(_currentUser?.uid);

  CollectionReference<Map<String, dynamic>> get _items => _firestore
      .collection('users')
      .doc(_currentUser?.uid)
      .collection('equipamentos');

  Future<List<String>> _uploadImagesEquipamentos({
    required List<String> images,
    required String uid,
  }) async {
    final upload = images.map((img) async {
      final String nameFile = img.split('/').last;
      final String name = '${DateTime.now().microsecondsSinceEpoch}_$nameFile';
      final Reference ref = _storage.ref('equipamentos/$uid/$name');

      await ref.putFile(File(img), SettableMetadata(contentType: 'image/jpeg'));

      return await ref.getDownloadURL();
    });

    return Future.wait(upload);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  Future<void> saveProduct(
    EquipamentosModel product,
    ImageManager imageManager,
  ) async {
    try {
      _setLoading(true);

      final DocumentSnapshot<Map<String, dynamic>> getUser = await _users.get();

      final UsersRepository usersRepository = UsersRepository.fromQueryDocument(
        queryDocument: getUser,
      );

      final List<String> imagesEquipamentos = await _uploadImagesEquipamentos(
        images: imageManager.listImages,
        uid: usersRepository.id,
      );

      await _items.doc().set({
        'uid': usersRepository.id,
        'name': usersRepository.name,
        'price': _convertForCent(product.price!),
        'timestamp': timeStamp,
        'nome_equipamento': product.name,
        'description': product.description,
        'periodo_dias': product.periodDays,
        'lat': usersRepository.latitude,
        'long': usersRepository.longitude,
        'status': true,
        'image_quipamentos': imagesEquipamentos,
        'nameProperty': usersRepository.nameProperty,
        'locationProperty': usersRepository.locationProperty,
        'url_photo': usersRepository.photo,
        'accept': false,
      });
    } catch (err) {
      log('error in Product_repository.dart');
    } finally {
      _setLoading(false);
    }
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
