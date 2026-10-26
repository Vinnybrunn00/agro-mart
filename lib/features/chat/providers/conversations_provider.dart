//  conversations_provider.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 23/10/2026
//

import 'dart:async';
import 'dart:developer';

import 'package:agroshare/features/chat/data/conversations_stream.dart';
import 'package:agroshare/features/chat/models/conversation_model.dart';
import 'package:flutter/material.dart';

/// Conversas do usuário em tempo real, compartilhadas entre a aba
/// "Conversas" e o contador de não lidas da barra de navegação.
class ConversationsProvider with ChangeNotifier {
  final ConversationsStream conversasStream = ConversationsStream();

  StreamSubscription<List<ConversationModel>>? _subscription;

  List<ConversationModel> _conversas = [];
  List<ConversationModel> get conversas => _conversas;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  String get uid => conversasStream.uid ?? '';

  /// Quantidade de conversas com mensagem nova.
  int get unreadCount => _conversas.where((c) => c.isUnread(uid)).length;

  ConversationsProvider() {
    _subscription = conversasStream.snapshot().listen(
      (conversas) {
        _conversas = conversas;
        _isLoading = false;
        _hasError = false;
        notifyListeners();
      },
      onError: (err) {
        log('Error in conversations_provider.dart');
        _isLoading = false;
        _hasError = true;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
