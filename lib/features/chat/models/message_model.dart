//  message_model.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 23/10/2026
//

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final int timestamp;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory MessageModel.fromQueryDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> message,
  ) {
    final Map<String, dynamic> data = message.data();

    return MessageModel(
      id: message.id,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] ?? 0,
    );
  }

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timestamp);

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'text': text,
    'timestamp': timestamp,
  };
}
