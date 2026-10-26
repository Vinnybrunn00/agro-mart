//  chat_provider.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 23/10/2026
//

import 'dart:developer';

import 'package:agroshare/features/chat/models/message_model.dart';
import 'package:agroshare/features/chat/data/chat_repository.dart';
import 'package:agroshare/core/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  final ChatRepository repository;

  ChatProvider({required this.repository}) {
    NotificationService.instance.activeChatId = repository.chatId;

    messages = repository.messagesSnapshot().map((list) {
      // chegou mensagem do outro lado com o chat aberto => marca como lida
      if (list.isNotEmpty && !isMine(list.first)) _markAsRead();
      return list;
    });
  }

  late final Stream<List<MessageModel>> messages;
  final TextEditingController textController = TextEditingController();

  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  bool _isSending = false;
  bool get isSending => _isSending;

  bool isMine(MessageModel message) => message.senderId == uid;

  Future<void> sendMessage() async {
    final String text = textController.text.trim();

    if (text.isEmpty || uid == null || _isSending) return;

    try {
      _setSending(true);
      textController.clear();

      await repository.sendMessage(
        MessageModel(
          id: '',
          senderId: uid!,
          text: text,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    } catch (err) {
      // devolve o texto para o usuário não perder a mensagem
      textController.text = text;
      log('Error in chat_provider.dart');
    } finally {
      _setSending(false);
    }
  }

  Future<void> _markAsRead() async {
    try {
      if (uid != null) await repository.markAsRead(uid!);
    } catch (err) {
      log('Error in chat_provider.dart');
    }
  }

  void _setSending(bool value) {
    _isSending = value;
    notifyListeners();
  }

  @override
  void dispose() {
    if (NotificationService.instance.activeChatId == repository.chatId) {
      NotificationService.instance.activeChatId = null;
    }
    textController.dispose();
    super.dispose();
  }
}
