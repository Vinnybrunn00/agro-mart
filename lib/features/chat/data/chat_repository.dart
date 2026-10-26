//  chat_repository.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 23/10/2026
//

import 'package:agroshare/features/chat/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Conversa entre o dono do equipamento e quem quer alugá-lo.
///
/// Cada par (equipamento, solicitante) tem uma única conversa em
/// chats/{equipamentoId}_{requesterId}, com as mensagens em
/// chats/{chatId}/messages.
class ChatRepository {
  final String equipamentoId;
  final String ownerId;
  final String requesterId;
  final String nomeEquipamento;

  ChatRepository({
    required this.equipamentoId,
    required this.ownerId,
    required this.requesterId,
    required this.nomeEquipamento,
  });

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get chatId => '${equipamentoId}_$requesterId';

  DocumentReference<Map<String, dynamic>> get chatReference =>
      _firestore.collection('chats').doc(chatId);

  CollectionReference<Map<String, dynamic>> get _messages =>
      chatReference.collection('messages');

  /// chats/{chatId}/messages => snapshot stream (mais recentes primeiro)
  Stream<List<MessageModel>> messagesSnapshot() {
    return _messages
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(MessageModel.fromQueryDocument).toList(),
        );
  }

  Future<void> sendMessage(MessageModel message) async {
    final WriteBatch batch = _firestore.batch();

    batch.set(chatReference, {
      'equipamentoId': equipamentoId,
      'ownerId': ownerId,
      'requesterId': requesterId,
      'nome_equipamento': nomeEquipamento,
      'participants': [ownerId, requesterId],
      'lastMessage': message.text,
      'lastSenderId': message.senderId,
      'timestamp': message.timestamp,
    }, SetOptions(merge: true));

    batch.set(_messages.doc(), message.toMap());

    await batch.commit();
  }

  /// Marca a conversa como lida pelo usuário (usado na lista de conversas).
  Future<void> markAsRead(String uid) async =>
      await chatReference.update({
        'lastRead.$uid': DateTime.now().millisecondsSinceEpoch,
      });
}
