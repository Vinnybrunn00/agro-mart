//  conversation_model.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 23/10/2026
//

import 'package:cloud_firestore/cloud_firestore.dart';

/// Resumo de uma conversa em chats/{chatId}, usado na lista de conversas.
class ConversationModel {
  final String chatId;
  final String equipamentoId;
  final String ownerId;
  final String requesterId;
  final String nomeEquipamento;
  final String lastMessage;
  final String lastSenderId;
  final int timestamp;
  final Map<String, dynamic> lastRead;

  const ConversationModel({
    required this.chatId,
    required this.equipamentoId,
    required this.ownerId,
    required this.requesterId,
    required this.nomeEquipamento,
    required this.lastMessage,
    required this.lastSenderId,
    required this.timestamp,
    required this.lastRead,
  });

  factory ConversationModel.fromQueryDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> conversa,
  ) {
    final Map<String, dynamic> data = conversa.data();

    return ConversationModel(
      chatId: conversa.id,
      equipamentoId: data['equipamentoId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      requesterId: data['requesterId'] ?? '',
      nomeEquipamento: data['nome_equipamento'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      lastSenderId: data['lastSenderId'] ?? '',
      timestamp: data['timestamp'] ?? 0,
      lastRead: Map<String, dynamic>.from(data['lastRead'] ?? {}),
    );
  }

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timestamp);

  /// uid de quem está do outro lado da conversa.
  String contactId(String uid) => uid == ownerId ? requesterId : ownerId;

  /// true quando o usuário é o dono do equipamento.
  bool isOwner(String uid) => uid == ownerId;

  bool isUnread(String uid) =>
      lastSenderId != uid && timestamp > ((lastRead[uid] as int?) ?? 0);
}
