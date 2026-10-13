import 'package:cloud_firestore/cloud_firestore.dart';

class RequestsRepository {
  final DocumentReference<Map<String, dynamic>> requestsReference;
  final String uid;
  final String name;
  final String photo;
  final String nameProperty;

  const RequestsRepository({
    required this.uid,
    required this.name,
    required this.photo,
    required this.nameProperty,
    required this.requestsReference,
  });

  factory RequestsRepository.fromQueryDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> requests,
  ) {
    final Map<String, dynamic> data = requests.data();

    return RequestsRepository(
      requestsReference: requests.reference,
      uid: data['id'],
      name: data['name'],
      photo: data['photo'],
      nameProperty: data['nameProperty'],
    );
  }
}
