//  chat_page.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 23/10/2026
//

import 'package:agroshare/features/chat/providers/chat_provider.dart';
import 'package:agroshare/features/chat/models/message_model.dart';
import 'package:agroshare/features/chat/data/chat_repository.dart';
import 'package:agroshare/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  final String equipamentoId;
  final String ownerId;
  final String requesterId;
  final String nomeEquipamento;

  /// Nome e foto de quem está do outro lado da conversa.
  final String contactName;
  final String? contactPhoto;

  const new({
    super.key,
    required this.equipamentoId,
    required this.ownerId,
    required this.requesterId,
    required this.nomeEquipamento,
    required this.contactName,
    this.contactPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(
        repository: ChatRepository(
          equipamentoId: equipamentoId,
          ownerId: ownerId,
          requesterId: requesterId,
          nomeEquipamento: nomeEquipamento,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.backgroundColor,
          titleSpacing: 0,
          title: Row(
            spacing: 10,
            children: [
              _Avatar(name: contactName, photo: contactPhoto),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      contactName,
                      overflow: .ellipsis,
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 16,
                        fontWeight: .w700,
                      ),
                    ),
                    Text(
                      nomeEquipamento,
                      overflow: .ellipsis,
                      style: TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: _MessagesList()),
              _InputBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessagesList extends StatelessWidget {
  const _MessagesList();

  @override
  Widget build(BuildContext context) {
    final ChatProvider chat = context.read<ChatProvider>();

    return StreamBuilder<List<MessageModel>>(
      stream: chat.messages,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.mainColor),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Não foi possível carregar o chat.'));
        }

        final List<MessageModel> messages = snapshot.data ?? [];

        if (messages.isEmpty) return _EmptyChat();

        // reverse: true mantém a lista ancorada na mensagem mais recente
        return ListView.builder(
          reverse: true,
          padding: .symmetric(horizontal: 12, vertical: 10),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final MessageModel message = messages[index];
            final MessageModel? previous = index + 1 < messages.length
                ? messages[index + 1]
                : null;

            return Column(
              children: [
                if (previous == null || !_sameDay(previous.date, message.date))
                  _DayLabel(date: message.date),
                _MessageBubble(
                  message: message,
                  isMine: chat.isMine(message),
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMine;

  const _MessageBubble({required this.message, required this.isMine});

  static final DateFormat _hourFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    final Color textColor = isMine ? AppColors.whiteColor : AppColors.textColor;

    return Align(
      alignment: isMine ? .centerRight : .centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .75,
        ),
        margin: .only(bottom: 6),
        padding: .fromLTRB(12, 8, 12, 6),
        decoration: BoxDecoration(
          color: isMine ? AppColors.mainColor : AppColors.backgroundColorCard,
          borderRadius: BorderRadius.only(
            topLeft: .circular(14),
            topRight: .circular(14),
            bottomLeft: .circular(isMine ? 14 : 4),
            bottomRight: .circular(isMine ? 4 : 14),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: .end,
          spacing: 2,
          children: [
            Align(
              alignment: .centerLeft,
              widthFactor: 1,
              child: Text(
                message.text,
                style: TextStyle(color: textColor, fontSize: 14.5),
              ),
            ),
            Text(
              _hourFormat.format(message.date),
              style: TextStyle(color: textColor.withAlpha(170), fontSize: 10.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final DateTime date;

  const _DayLabel({required this.date});

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  String get _label {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime day = DateTime(date.year, date.month, date.day);
    final int diff = today.difference(day).inDays;

    if (diff == 0) return 'Hoje';
    if (diff == 1) return 'Ontem';
    return _dateFormat.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .symmetric(vertical: 10),
      padding: .symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.mainColor.withAlpha(25),
        borderRadius: .circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: AppColors.mainColor,
          fontSize: 11.5,
          fontWeight: .w600,
        ),
      ),
    );
  }
}

class _EmptyChat extends StatelessWidget {
  const _EmptyChat();

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
              Icons.chat_bubble_outline,
              color: AppColors.mainColor.withAlpha(120),
              size: 48,
            ),
            Text(
              'Nenhuma mensagem ainda.\nEnvie a primeira para começar a conversa.',
              textAlign: .center,
              style: TextStyle(color: AppColors.greyColor, fontSize: 13.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar();

  @override
  Widget build(BuildContext context) {
    final ChatProvider chat = Provider.of<ChatProvider>(context);

    return Container(
      padding: .fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border(top: BorderSide(color: AppColors.blackColorAlpha55)),
      ),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Container(
              padding: .symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.backgroundColorCard,
                borderRadius: .circular(24),
              ),
              child: TextField(
                controller: chat.textController,
                minLines: 1,
                maxLines: 5,
                textCapitalization: .sentences,
                keyboardType: .multiline,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Digite uma mensagem',
                  hintStyle: TextStyle(color: AppColors.greyColor),
                ),
              ),
            ),
          ),
          Material(
            color: AppColors.mainColor,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: chat.isSending ? null : chat.sendMessage,
              customBorder: const CircleBorder(),
              child: SizedBox(
                height: 46,
                width: 46,
                child: Icon(
                  Icons.send_rounded,
                  color: AppColors.whiteColor,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
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
      radius: 19,
      backgroundColor: AppColors.mainColor.withAlpha(30),
      backgroundImage: hasPhoto ? NetworkImage(photo!) : null,
      child: hasPhoto
          ? null
          : Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(
                color: AppColors.mainColor,
                fontWeight: .w700,
              ),
            ),
    );
  }
}
