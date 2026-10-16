import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EquipamentoRepository {
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

  EquipamentoRepository({
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
  });

  factory EquipamentoRepository.fromQueryDocument(
    QueryDocumentSnapshot<Map<String, dynamic>>? equipamentos,
  ) {
    final Map<String, dynamic>? data = equipamentos?.data();

    return EquipamentoRepository(
      equipamentoReference: equipamentos?.reference,
      requestCollection: equipamentos?.reference.collection('requests'),
      id: equipamentos?.id,
      referenceId: equipamentos!.reference.id,
      description: data?['description'],
      images: data?['image_quipamentos'],
      lat: data?['lat'],
      locationProperty: data?['locationProperty'],
      long: data?['long'],
      name: data?['name'],
      nameProperty: data?['nameProperty'],
      nomeEquipamento: data?['nome_equipamento'],
      periodDias: data?['periodo_dias'],
      price: _convertCentInReais(data?['price']),
      status: data?['status'],
      timestamp: data?['timestamp'],
      uid: data?['uid'],
      urlPhotoUser: data?['url_photo'],
      accept: data?['accept'],
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
}
