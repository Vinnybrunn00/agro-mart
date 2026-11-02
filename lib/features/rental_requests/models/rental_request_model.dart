/*
 * lib/features/rental_requests/models/rental_request_model.dart
 *
 * Modelo de uma solicitação de aluguel.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 09/10/2026
 */

import 'package:cloud_firestore/cloud_firestore.dart';

class RentalRequestModel {
  final DocumentReference<Map<String, dynamic>> requestsReference;
  final String uid;
  final String name;
  final String photo;
  final String nameProperty;

  const RentalRequestModel({
    required this.uid,
    required this.name,
    required this.photo,
    required this.nameProperty,
    required this.requestsReference,
  });

  factory RentalRequestModel.fromQueryDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> requests,
  ) {
    final Map<String, dynamic> data = requests.data();

    return RentalRequestModel(
      requestsReference: requests.reference,
      uid: data['id'],
      name: data['name'],
      photo: data['photo'],
      nameProperty: data['nameProperty'],
    );
  }

  Future<void> delete() async => await requestsReference.delete();

  Future<void> updateAccept() async =>
      await requestsReference.update({'accept': true});
}
