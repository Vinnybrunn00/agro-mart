//  conversations_tab.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 23/10/2026
//

import 'package:agroshare/features/chat/providers/conversations_provider.dart';
import 'package:agroshare/features/chat/data/conversations_stream.dart';
import 'package:agroshare/features/chat/models/conversation_model.dart';
import 'package:agroshare/core/navigation/app_navigator.dart';
import 'package:agroshare/core/theme/app_colors.dart';
import 'package:agroshare/features/chat/ui/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConversationsTab extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final ConversationsProvider provider = Provider.of<ConversationsProvider>(context);

    if (provider.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.mainColor),
      );
    }

    if (provider.hasError) {
      return Center(child: Text('Não foi possível carregar as conversas.'));
    }

    final List<ConversationModel> conversas = provider.conversas;

    if (conversas.isEmpty) return _EmptyConversations();

    return ListView.builder(
      padding: .symmetric(vertical: 10),
      itemCount: conversas.length,
      itemBuilder: (context, index) => _ConversationTile(
        conversa: conversas[index],
        uid: provider.uid,
        conversasStream: provider.conversasStream,
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationModel conversa;
  final String uid;
  final ConversationsStream conversasStream;

  const _ConversationTile({
    required this.conversa,
    required this.uid,
    required this.conversasStream,
  });

  static final DateFormat _hourFormat = DateFormat('HH:mm');
  static final DateFormat _dateFormat = DateFormat('dd/MM/yy');

  String get _dateLabel {
    final DateTime now = DateTime.now();
    final DateTime date = conversa.date;
    final bool isToday =
        now.year == date.year && now.month == date.month && now.day == date.day;

    return isToday ? _hourFormat.format(date) : _dateFormat.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final bool unread = conversa.isUnread(uid);
    final bool isMine = conversa.lastSenderId == uid;

    return StreamBuilder(
      stream: conversasStream.contactSnapshot(conversa.contactId(uid)),
      builder: (context, snapshot) {
        final Map<String, dynamic>? data = snapshot.data?.data();
        final String name = data?['name'] ?? 'Carregando...';
        final String? photo = data?['photo'];

        return Container(
          margin: .only(left: 16, right: 16, top: 10),
          decoration: BoxDecoration(
            borderRadius: .circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: AppColors.backgroundColorCard,
            borderRadius: .circular(14),
            clipBehavior: .antiAlias,
            child: InkWell(
              onTap: data == null
                  ? null
                  : () async {
                      final ChatPage chatPage = ChatPage(
                        equipamentoId: conversa.equipamentoId,
                        ownerId: conversa.ownerId,
                        requesterId: conversa.requesterId,
                        nomeEquipamento: conversa.nomeEquipamento,
                        contactName: name,
                        contactPhoto: photo,
                      );
                      await AppNavigator.push(context, chatPage);
                    },
              child: Padding(
                padding: .all(12),
                child: Row(
                  spacing: 12,
                  children: [
                    _Avatar(name: name, photo: photo),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 2,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: .w600,
                              color: AppColors.textColor,
                            ),
                          ),
                          Row(
                            spacing: 6,
                            children: [
                              _RoleChip(isOwner: conversa.isOwner(uid)),
                              Expanded(
                                child: Text(
                                  conversa.nomeEquipamento,
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: AppColors.mainColor,
                                    fontWeight: .w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${isMine ? 'Você: ' : ''}${conversa.lastMessage}',
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: unread
                                  ? AppColors.textColor
                                  : AppColors.greyColor,
                              fontWeight: unread ? .w600 : .w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: .end,
                      spacing: 8,
                      children: [
                        Text(
                          _dateLabel,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: unread
                                ? AppColors.mainColor
                                : AppColors.greyColor,
                            fontWeight: unread ? .w700 : .w400,
                          ),
                        ),
                        if (unread)
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              shape: .circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Indica se o usuário é o dono do equipamento ou quem quer alugar.
class _RoleChip extends StatelessWidget {
  final bool isOwner;

  const _RoleChip({required this.isOwner});

  @override
  Widget build(BuildContext context) {
    final Color color = isOwner ? AppColors.mainColor : Colors.orange.shade800;

    return Container(
      padding: .symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: .circular(20),
      ),
      child: Text(
        isOwner ? 'Meu anúncio' : 'Aluguel',
        style: TextStyle(fontSize: 10.5, fontWeight: .w600, color: color),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String? photo;

  const _Avatar({required this.name, this.photo});

  @override
  Widget build(BuildContext context) {
    final bool hasPhoto = photo != null && photo!.isNotEmpty;

    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.mainColor.withAlpha(30),
      backgroundImage: hasPhoto ? NetworkImage(photo!) : null,
      child: hasPhoto
          ? null
          : Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(
                color: AppColors.mainColor,
                fontSize: 18,
                fontWeight: .w700,
              ),
            ),
    );
  }
}

class _EmptyConversations extends StatelessWidget {
  const _EmptyConversations();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: .all(32),
        child: Column(
          mainAxisSize: .min,
          spacing: 10,
          children: [
            Icon(
              Icons.forum_outlined,
              color: AppColors.mainColor.withAlpha(120),
              size: 48,
            ),
            Text(
              'Você ainda não tem conversas.\nAs mensagens sobre equipamentos aparecem aqui.',
              textAlign: .center,
              style: TextStyle(color: AppColors.greyColor, fontSize: 13.5),
            ),
          ],
        ),
      ),
    );
  }
}
