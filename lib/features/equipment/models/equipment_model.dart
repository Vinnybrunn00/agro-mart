/*
 * lib/features/equipment/models/equipment_model.dart
 *
 * Modelo de um equipamento anunciado.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 09/10/2026
 */

import 'package:agroshare/features/profile/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class EquipmentModel {
  final DocumentReference<Map<String, dynamic>>? equipamentoReference;
  final CollectionReference<Map<String, dynamic>>? requestCollection;
  final String? id;
  final String referenceId;
  final String description;
  final List images;
  final double lat;
  final String locationProperty;
  final double long;
  final String name;
  final String nameProperty;
  final String nomeEquipamento;
  final String periodDias;
  final String price;
  final bool status;
  final int timestamp;
  final String uid;
  final String urlPhotoUser;
  final bool accept;
  final double distanceKm;
  final bool isNotView;

  EquipmentModel({
    required this.requestCollection,
    required this.id,
    required this.referenceId,
    required this.description,
    required this.images,
    required this.lat,
    required this.locationProperty,
    required this.long,
    required this.name,
    required this.nameProperty,
    required this.nomeEquipamento,
    required this.periodDias,
    required this.price,
    required this.status,
    required this.timestamp,
    required this.uid,
    required this.equipamentoReference,
    required this.urlPhotoUser,
    required this.accept,
    required this.distanceKm,
    required this.isNotView,
  });

  factory EquipmentModel.fromQueryDocument(
    QueryDocumentSnapshot<Map<String, dynamic>>? equipamentos, [
    UserModel? userModel,
  ]) {
    final Map<String, dynamic>? data = equipamentos?.data();

    final double lat = (data?['lat'] as num).toDouble();
    final double long = (data?['long'] as num).toDouble();
    final String uid = data?['uid'];

    return EquipmentModel(
      equipamentoReference: equipamentos?.reference,
      requestCollection: equipamentos?.reference.collection('requests'),
      id: equipamentos?.id,
      referenceId: equipamentos!.reference.id,
      description: data?['description'],
      images: data?['image_quipamentos'],
      lat: lat,
      locationProperty: data?['locationProperty'],
      long: long,
      name: data?['name'],
      nameProperty: data?['nameProperty'],
      nomeEquipamento: data?['nome_equipamento'],
      periodDias: data?['periodo_dias'],
      price: _convertCentInReais(data?['price']),
      status: data?['status'],
      timestamp: data?['timestamp'],
      uid: uid,
      urlPhotoUser: data?['url_photo'],
      accept: data?['accept'],
      distanceKm: userModel != null
          ? _getDistanceKm(currentUser: userModel, lat: lat, long: long)
          : 0,
      isNotView: _isNotView(currentUser: userModel, uid: uid),
    );
  }

  static String _convertCentInReais(int cent) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    double real = cent / 100;
    return formatter.format(real);
  }

  Future<void> updateAccept() async =>
      await equipamentoReference?.update({'accept': true});

  static bool _isNotView({
    required UserModel? currentUser,
    required String uid,
  }) => currentUser?.id == uid;

  static double _getDistanceKm({
    required UserModel currentUser,
    required double lat,
    required double long,
  }) =>
      Geolocator.distanceBetween(
        currentUser.latitude,
        currentUser.longitude,
        lat,
        long,
      ) /
      1000;
}
