//  conversations_stream.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 23/10/2026
//

import 'package:agroshare/features/chat/models/conversation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConversationsStream {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? get uid => _firebaseAuth.currentUser?.uid;

  /// chats onde o usuário participa => snapshot stream (mais recentes primeiro)
  ///
  /// A ordenação é feita no app para não exigir índice composto
  /// (participants + timestamp) no Firestore.
  Stream<List<ConversationModel>> snapshot() {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
          final List<ConversationModel> conversas = snapshot.docs
              .map(ConversationModel.fromQueryDocument)
              .toList();

          conversas.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return conversas;
        });
  }

  /// users/${uid} => snapshot stream do contato da conversa
  Stream<DocumentSnapshot<Map<String, dynamic>>> contactSnapshot(String id) =>
      _firestore.collection('users').doc(id).snapshots();
}
