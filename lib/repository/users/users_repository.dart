import 'package:cloud_firestore/cloud_firestore.dart';

class UsersRepository {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String nameProperty;
  final String locationProperty;
  final String photo;

  UsersRepository({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.nameProperty,
    required this.locationProperty,
    required this.photo,
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
      nameProperty: data?['nameProperty'] as String,
      locationProperty: data?['locationProperty'] as String,
      photo: data?['photo'] as String,
    );
  }
}
