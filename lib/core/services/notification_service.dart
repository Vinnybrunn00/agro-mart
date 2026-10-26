//  notification_service.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 23/10/2026
//

import 'dart:async';
import 'dart:developer';

import 'package:agroshare/features/profile/models/current_user_model.dart';
import 'package:agroshare/features/equipment/models/equipment_model.dart';
import 'package:agroshare/features/chat/ui/chat_page.dart';
import 'package:agroshare/features/equipment/ui/manage_equipment_page.dart';
import 'package:agroshare/features/rental_requests/ui/my_rental_requests_page.dart';
import 'package:agroshare/core/utils/app_messenger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// Push notifications (FCM).
///
/// As notificações são disparadas pelas Cloud Functions em functions/:
///   - tipo 'solicitacao' => nova solicitação de aluguel (para o dono)
///   - tipo 'aceite'      => solicitação aceita (para quem solicitou)
///   - tipo 'chat'        => nova mensagem (para o outro participante)
///
/// Com o app em segundo plano/fechado o sistema mostra a notificação; com o
/// app aberto ela aparece como mensagem flutuante ([AppMessenger.showMessage]).
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  /// Usada para navegar a partir de uma notificação, fora da árvore de widgets.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Chat aberto no momento; mensagens dele não geram aviso em primeiro plano.
  String? activeChatId;

  Future<void> init() async {
    await _messaging.requestPermission();

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) await _saveToken();
    });

    _messaging.onTokenRefresh.listen((_) => _saveToken());

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_open);

    // app aberto a partir de uma notificação com ele fechado
    final RemoteMessage? initial = await _messaging.getInitialMessage();
    if (initial != null) unawaited(_openWhenReady(initial));
  }

  /// Deve ser chamado ANTES do signOut, enquanto o usuário ainda tem
  /// permissão para alterar o próprio documento.
  Future<void> removeToken() async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      final String? token = await _messaging.getToken();

      if (uid == null || token == null) return;

      await _firestore.collection('users').doc(uid).update({
        'fcmTokens': FieldValue.arrayRemove([token]),
      });
      await _messaging.deleteToken();
    } catch (err) {
      log('Error in notification_service.dart');
    }
  }

  Future<void> _saveToken() async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      final String? token = await _messaging.getToken();

      if (uid == null || token == null) return;

      await _firestore.collection('users').doc(uid).update({
        'fcmTokens': FieldValue.arrayUnion([token]),
      });
    } catch (err) {
      log('Error in notification_service.dart');
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    final BuildContext? context = navigatorKey.currentContext;
    final RemoteNotification? notification = message.notification;

    if (context == null || notification == null) return;
    if (message.data['chatId'] != null &&
        message.data['chatId'] == activeChatId) {
      return;
    }

    AppMessenger.showMessage(
      context,
      title: notification.title,
      message: notification.body ?? '',
      icon: message.data['tipo'] == 'chat'
          ? Icons.chat_bubble_outline
          : Icons.notifications_none_rounded,
      duration: Duration(seconds: 4),
      actionLabel: 'Abrir',
      onAction: () => _open(message),
    );
  }

  Future<void> _openWhenReady(RemoteMessage message) async {
    while (navigatorKey.currentState == null ||
        FirebaseAuth.instance.currentUser == null) {
      await Future.delayed(Duration(milliseconds: 200));
    }
    await _open(message);
  }

  Future<void> _open(RemoteMessage message) async {
    try {
      final Widget? page = await _pageFor(message.data);
      if (page == null) return;

      await navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => page),
      );
    } catch (err) {
      log('Error in notification_service.dart');
    }
  }

  Future<Widget?> _pageFor(Map<String, dynamic> data) async {
    switch (data['tipo']) {
      case 'chat':
        return ChatPage(
          equipamentoId: data['equipamentoId'],
          ownerId: data['ownerId'],
          requesterId: data['requesterId'],
          nomeEquipamento: data['nome_equipamento'] ?? '',
          contactName: data['contactName'] ?? '',
          contactPhoto: data['contactPhoto'],
        );

      case 'solicitacao':
        // fromQueryDocument espera um QueryDocumentSnapshot
        final QuerySnapshot<Map<String, dynamic>> query = await _firestore
            .collection('users')
            .doc(data['ownerId'])
            .collection('equipamentos')
            .where(FieldPath.documentId, isEqualTo: data['equipamentoId'])
            .limit(1)
            .get();

        if (query.docs.isEmpty) return null;

        return ManageEquipmentPage(
          equipamentos: EquipmentModel.fromQueryDocument(query.docs.first),
        );

      case 'aceite':
        final String? uid = FirebaseAuth.instance.currentUser?.uid;
        final DocumentSnapshot<Map<String, dynamic>> user = await _firestore
            .collection('users')
            .doc(uid)
            .get();

        if (user.data() == null) return null;

        return MyRentalRequestsPage(
          currentUser: CurrentUserModel.fromMap(data: user.data()!),
        );
    }

    return null;
  }
}
