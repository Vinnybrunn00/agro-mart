import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyEquipmentStream {
  User? get _currentUser => FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> get _docUser =>
      _firestore.collection('users').doc(_currentUser?.uid);

  CollectionReference<Map<String, dynamic>> get _colletcionEquipamento =>
      _docUser.collection('equipamentos');

  /// users/${uid}/equipamentos => snapshot stream
  Stream<QuerySnapshot<Map<String, dynamic>>> equipamentoSnapshot() {
    return _colletcionEquipamento
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
