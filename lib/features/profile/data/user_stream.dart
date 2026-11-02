/*
 * lib/features/profile/data/user_stream.dart
 *
 * Stream do documento do usuário autenticado.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 01/10/2026
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserStream {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  String? get uid => _firebaseAuth.currentUser?.uid;

  Stream<DocumentSnapshot<Map<String, dynamic>>> snapshot() =>
      _users.doc(uid).snapshots();
}
