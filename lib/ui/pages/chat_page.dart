import 'package:agroshare/repository/users/users_repository.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final DocumentReference<Map<String, dynamic>> chatReference;
  final UsersRepository currentUser;
  final String peerName;
  final String peerPhoto;
  final String? subtitle;

  const new({
    super.key,
    required this.chatReference,
    required this.currentUser,
    required this.peerName,
    required this.peerPhoto,
    this.subtitle,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  late final CollectionReference<Map<String, dynamic>> _messages = widget
      .chatReference
      .collection('messages');

  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stream = _messages
      .orderBy('timestamp', descending: true)
      .snapshots();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();

    final UsersRepository user = widget.currentUser;
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final WriteBatch batch = FirebaseFirestore.instance.batch();

    // o id do chat é o uid de quem iniciou a conversa
    batch.set(widget.chatReference, {
      if (widget.chatReference.id == user.id) ...{
        'id': user.id,
        'name': user.name,
        'photo': user.photo,
        'nameProperty': user.nameProperty,
      },
      'lastMessage': text,
      'lastSenderId': user.id,
      'timestamp': timestamp,
    }, SetOptions(merge: true));

    batch.set(_messages.doc(), {
      'senderId': user.id,
      'text': text,
      'timestamp': timestamp,
    });

    try {
      await batch.commit();
    } catch (_) {
      if (!mounted) return;
      _controller.text = text;
      Utils.showMessage(
        context,
        message: 'Não foi possível enviar a mensagem. Tente novamente.',
        type: .error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundColor,
        titleSpacing: 0,
        title: Row(
          spacing: 10,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.mainColor.withAlpha(28),
              backgroundImage: NetworkImage(widget.peerPhoto),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    widget.peerName,
                    overflow: .ellipsis,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 15,
                      fontWeight: .w700,
                    ),
                  ),
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      overflow: .ellipsis,
                      style: TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _EmptyChat('Não foi possível carregar as mensagens.');
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mainColor,
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return _EmptyChat(
                    'Envie uma mensagem para ${widget.peerName}.',
                  );
                }

                return ListView.separated(
                  reverse: true,
                  padding: .symmetric(horizontal: 16, vertical: 12),
                  itemCount: docs.length,
                  separatorBuilder: (_, _) => SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> data = docs[index].data();

                    return _MessageBubble(
                      text: data['text'] ?? '',
                      timestamp: data['timestamp'] ?? 0,
                      isMine: data['senderId'] == widget.currentUser.id,
                    );
                  },
                );
              },
            ),
          ),
          _ChatInput(controller: _controller, onSend: _send),
        ],
      ),
    );
  }
}

class _EmptyChat extends StatelessWidget {
  final String label;

  const _EmptyChat(this.label);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: .all(24),
        child: Column(
          mainAxisSize: .min,
          spacing: 10,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              color: AppColors.mainColor.withAlpha(200),
              size: 40,
            ),
            Text(
              label,
              textAlign: .center,
              style: TextStyle(color: AppColors.greyColor, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final int timestamp;
  final bool isMine;

  const _MessageBubble({
    required this.text,
    required this.timestamp,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = isMine ? AppColors.whiteColor : AppColors.textColor;

    return Align(
      alignment: isMine ? .centerRight : .centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        child: Container(
          padding: .symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isMine ? AppColors.mainColor : AppColors.backgroundColorCard,
            borderRadius: .only(
              topLeft: .circular(14),
              topRight: .circular(14),
              bottomLeft: .circular(isMine ? 14 : 4),
              bottomRight: .circular(isMine ? 4 : 14),
            ),
          ),
          child: Column(
            crossAxisAlignment: .end,
            mainAxisSize: .min,
            spacing: 2,
            children: [
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 14, height: 1.35),
              ),
              Text(
                DateFormat('HH:mm')
                    .format(DateTime.fromMillisecondsSinceEpoch(timestamp)),
                style: TextStyle(
                  color: textColor.withAlpha(170),
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function()? onSend;

  const _ChatInput({required this.controller, this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border(top: BorderSide(color: AppColors.blackColorAlpha55)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: .symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: .end,
            spacing: 10,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 500,
                  cursorHeight: 18,
                  cursorWidth: 1,
                  keyboardType: .multiline,
                  textCapitalization: .sentences,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.whiteColor,
                    counterText: '',
                    hintText: 'Escreva uma mensagem',
                    hintStyle: TextStyle(
                      color: AppColors.blackColorAlpha55,
                      fontSize: 12.5,
                    ),
                    contentPadding: .symmetric(horizontal: 12, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: .circular(11),
                      borderSide: BorderSide(
                        color: AppColors.blackColorAlpha55,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: .circular(11),
                      borderSide: BorderSide(color: AppColors.mainColor),
                    ),
                  ),
                ),
              ),
              Material(
                color: AppColors.mainColor,
                borderRadius: .circular(12),
                child: InkWell(
                  onTap: onSend,
                  borderRadius: .circular(12),
                  child: SizedBox(
                    height: 44,
                    width: 44,
                    child: Icon(
                      Icons.send_rounded,
                      color: AppColors.whiteColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
