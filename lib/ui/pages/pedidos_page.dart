import 'dart:developer';

import 'package:agroshare/models/profile/current_user_model.dart';
import 'package:agroshare/navigator/navigator_app.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/pages/chat/chat_page.dart';
import 'package:agroshare/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PedidosPage extends StatelessWidget {
  final CurrentUser currentUser;
  new({super.key, required this.currentUser});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Meus pedidos'),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _firestore.collectionGroup('requests').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) return Text('Error');

                  // Filtra antes de montar a lista para que a mensagem de
                  // vazio apareça corretamente.
                  final requests = (snapshot.data?.docs ?? [])
                      .where((doc) => doc.data()['id'] == currentUser.id)
                      .toList();

                  if (requests.isEmpty) {
                    return Center(
                      child: Text('Você não solicitou nenhum aluguel.'),
                    );
                  }

                  return ListView.builder(
                    padding: .symmetric(vertical: 10),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final requestsReference = requests[index].reference;
                      final bool accepted =
                          requests[index].data()['accept'] == true;

                      // requests ficam em equipamentos/{id}/requests/{uid},
                      // então o pai do documento é o equipamento solicitado.
                      final DocumentReference<Map<String, dynamic>>?
                      equipamentoReference = requestsReference.parent.parent;

                      if (equipamentoReference == null) {
                        return SizedBox.shrink();
                      }

                      return _BoxPedido(
                        equipamentoReference: equipamentoReference,
                        requestsReference: requestsReference,
                        accepted: accepted,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoxPedido extends StatelessWidget {
  final DocumentReference<Map<String, dynamic>> requestsReference;
  final DocumentReference<Map<String, dynamic>> equipamentoReference;
  final bool accepted;

  const _BoxPedido({
    required this.equipamentoReference,
    required this.requestsReference,
    required this.accepted,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: equipamentoReference.snapshots(),
      builder: (context, snapshot) {
        final Map<String, dynamic>? data = snapshot.data?.data();

        if (snapshot.hasData && data == null) return SizedBox.shrink();

        final _PedidoInfo? info = data == null ? null : _PedidoInfo(data);

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
              onTap: info == null
                  ? null
                  : () => _showDetalhes(context, info, requestsReference),
              child: Padding(
                padding: .all(10),
                child: Row(
                  spacing: 12,
                  children: [
                    _Thumbnail(url: info?.image),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 4,
                        children: [
                          Text(
                            info?.nomeEquipamento ?? 'Carregando...',
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: .w600,
                              color: AppColors.textColor,
                            ),
                          ),
                          if (info != null) ...[
                            Text(
                              info.nameProperty,
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.greyColor,
                              ),
                            ),
                            Text(
                              '${info.price} · ${info.periodLabel}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: .w600,
                                color: AppColors.mainColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: .end,
                      spacing: 8,
                      children: [
                        _StatusChip(accepted: accepted),
                        Icon(Icons.chevron_right, color: AppColors.greyColor),
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

  void _showDetalhes(
    BuildContext context,
    _PedidoInfo info,
    DocumentReference<Map<String, dynamic>> requestsReference,
  ) async {
    final Size size = MediaQuery.of(context).size;
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.backgroundColorCard,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(18)),
      ),
      builder: (context) => SafeArea(
        child: Container(
          height: size.height * .55,
          padding: .only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 10,
            children: [
              if (info.image != null)
                ClipRRect(
                  borderRadius: .circular(12),
                  child: Image.network(
                    info.image!,
                    height: 160,
                    width: double.infinity,
                    fit: .cover,
                    errorBuilder: (_, _, _) => SizedBox.shrink(),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      info.nomeEquipamento,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: .w700,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  _StatusChip(accepted: accepted),
                ],
              ),
              Text(
                '${info.price} · ${info.periodLabel}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: .w600,
                  color: AppColors.mainColor,
                ),
              ),
              Text(
                'Proprietário: ${info.name} (${info.nameProperty})',
                style: TextStyle(fontSize: 14, color: AppColors.textColor),
              ),
              if (info.locationProperty.isNotEmpty)
                Text(
                  info.locationProperty,
                  style: TextStyle(fontSize: 13, color: AppColors.greyColor),
                ),
              if (info.description.isNotEmpty)
                Text(
                  info.description,
                  style: TextStyle(fontSize: 14, color: AppColors.textColor),
                  overflow: .ellipsis,
                ),
              SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    log(requestsReference.id);

                    await NavigatorsApp.push(context, ChatPage());
                  },
                  icon: Icon(Icons.chat_bubble_outline),
                  label: Text('Chat'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    foregroundColor: AppColors.whiteColor,
                    padding: .symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await requestsReference.delete();
                    await equipamentoReference.update({'accept': false});

                    if (!context.mounted) return;
                    await Navigator.of(context).maybePop();

                    if (!context.mounted) return;
                    Utils.showMessage(
                      context,
                      message: 'Solicitação Cancelada com sucesso!',
                    );
                  },
                  icon: Icon(Icons.close_rounded, size: 20),
                  label: Text('Cancelar solicitação'),
                  style:
                      OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        backgroundColor: Colors.red.withAlpha(15),
                        side: BorderSide(color: Colors.red.withAlpha(80)),
                        padding: .symmetric(vertical: 14),
                        textStyle: TextStyle(fontSize: 15, fontWeight: .w600),
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(12),
                        ),
                      ).copyWith(
                        overlayColor: WidgetStatePropertyAll(
                          Colors.red.withAlpha(30),
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

class _PedidoInfo {
  final String nomeEquipamento;
  final String name;
  final String nameProperty;
  final String locationProperty;
  final String description;
  final String price;
  final String periodLabel;
  final String? image;

  _PedidoInfo(Map<String, dynamic> data)
    : nomeEquipamento = data['nome_equipamento'] ?? '',
      name = data['name'] ?? '',
      nameProperty = data['nameProperty'] ?? '',
      locationProperty = data['locationProperty'] ?? '',
      description = data['description'] ?? '',
      price = _formatPrice(data['price']),
      periodLabel = _formatPeriod(data['periodo_dias']),
      image = _firstImage(data['image_quipamentos']);

  static String _formatPrice(dynamic cent) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    return formatter.format(((cent as num?) ?? 0) / 100);
  }

  static String _formatPeriod(dynamic days) {
    final String value = '${days ?? ''}';
    return value == '1' ? '1 dia' : '$value dias';
  }

  static String? _firstImage(dynamic images) {
    if (images is List && images.isNotEmpty) return '${images.first}';
    return null;
  }
}

class _Thumbnail extends StatelessWidget {
  final String? url;

  const _Thumbnail({this.url});

  @override
  Widget build(BuildContext context) {
    final Widget placeholder = Container(
      color: AppColors.mainColor.withAlpha(30),
      child: Icon(Icons.agriculture, color: AppColors.mainColor),
    );

    return ClipRRect(
      borderRadius: .circular(10),
      child: SizedBox(
        width: 72,
        height: 72,
        child: url == null
            ? placeholder
            : Image.network(
                url!,
                fit: .cover,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool accepted;

  const _StatusChip({required this.accepted});

  @override
  Widget build(BuildContext context) {
    final Color color = accepted ? AppColors.mainColor : Colors.orange.shade800;

    return Container(
      padding: .symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: .circular(20),
      ),
      child: Text(
        accepted ? 'Aceito' : 'Pendente',
        style: TextStyle(fontSize: 11, fontWeight: .w600, color: color),
      ),
    );
  }
}
