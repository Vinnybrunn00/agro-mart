import 'package:cloud_firestore/cloud_firestore.dart';

class UsersRepository {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  UsersRepository({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory UsersRepository.fromQueryDocument({
    required DocumentSnapshot<Map<String, dynamic>> queryDocument,
  }) {
    final Map<String, dynamic>? data = queryDocument.data();
    return UsersRepository(
      id: queryDocument.id,
      name: data?['name'] as String,
      latitude: data?['lat'] as double,
      longitude: data?['long'] as double,
    );
  }
}
