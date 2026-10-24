import 'package:agroshare/navigator/navigator_app.dart';
import 'package:agroshare/repository/equipamento/equipamento_repository.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/pages/current_anuncio_page.dart';
import 'package:flutter/material.dart';

class BoxFerramentasAnuncio extends StatelessWidget {
  final EquipamentoRepository equipamentos;

  const new({super.key, required this.equipamentos});

  String get _periodLabel {
    final String days = equipamentos.periodDias;
    return days == '1' ? '1 dia' : '$days dias';
  }

  /// Ex.: Publicado hoje, Publicado há 3 dias, Publicado há 2 meses...
  String get _publishedLabel {
    final DateTime created = DateTime.fromMillisecondsSinceEpoch(
      equipamentos.timestamp,
    );
    final int days = DateUtils.dateOnly(DateTime.now())
        .difference(DateUtils.dateOnly(created))
        .inDays;

    if (days <= 0) return 'Publicado hoje';
    if (days == 1) return 'Publicado ontem';
    if (days < 30) return 'Publicado há $days dias';

    final int months = days ~/ 30;

    if (months < 12) {
      return months == 1 ? 'Publicado há 1 mês' : 'Publicado há $months meses';
    }

    final int years = days ~/ 365;
    return years <= 1 ? 'Publicado há 1 ano' : 'Publicado há $years anos';
  }

  @override
  Widget build(BuildContext context) {
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
          onTap: () async {
            final AnuncioEntityPage currentAnuncio = AnuncioEntityPage(
              equipamentos: equipamentos,
            );
            await NavigatorsApp.push(context, currentAnuncio);
          },
          child: Column(
            children: [
              Padding(
                padding: .all(12),
                child: Row(
                  spacing: 12,
                  children: [
                    _Thumbnail(
                      url: equipamentos.images.isNotEmpty
                          ? equipamentos.images.first as String
                          : null,
                      isActive: equipamentos.status,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 3,
                        children: [
                          Text(
                            equipamentos.nomeEquipamento,
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: .w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Row(
                            spacing: 6,
                            children: [
                              Text(
                                equipamentos.price,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: .w700,
                                  color: AppColors.mainColor,
                                ),
                              ),
                              Text(
                                '·',
                                style: TextStyle(color: AppColors.greyColor),
                              ),
                              Text(
                                _periodLabel,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _publishedLabel,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.greyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusBadge(isActive: equipamentos.status),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 1, color: AppColors.borderColor),
              Padding(
                padding: .symmetric(horizontal: 12, vertical: 9),
                child: Row(
                  spacing: 4,
                  children: [
                    Expanded(child: _RequestsCount(equipamentos: equipamentos)),
                    Text(
                      'Gerenciar',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: .w600,
                        color: AppColors.mainColor,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.mainColor,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final String? url;
  final bool isActive;

  const _Thumbnail({required this.url, required this.isActive});

  static const double _size = 64;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: .circular(10),
      child: SizedBox(
        height: _size,
        width: _size,
        child: url == null
            ? const _ThumbnailPlaceholder()
            : Opacity(
                opacity: isActive ? 1 : 0.5,
                child: Image.network(
                  url!,
                  fit: .cover,
                  // Decodifica no tamanho exibido para poupar memória na lista.
                  cacheWidth: (_size * MediaQuery.devicePixelRatioOf(context))
                      .round(),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const _ThumbnailPlaceholder();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const _ThumbnailPlaceholder();
                  },
                ),
              ),
      ),
    );
  }
}

class _ThumbnailPlaceholder extends StatelessWidget {
  const _ThumbnailPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundColor,
      child: Icon(
        Icons.agriculture_outlined,
        color: AppColors.mainColor.withAlpha(140),
        size: 28,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final Color color = isActive ? AppColors.mainColor : AppColors.greyColor;

    return Container(
      padding: .symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: .circular(18),
      ),
      child: Row(
        mainAxisSize: .min,
        spacing: 5,
        children: [
          Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(color: color, shape: .circle),
          ),
          Text(
            isActive ? 'Ativo' : 'Desativado',
            style: TextStyle(fontSize: 11, color: color, fontWeight: .w600),
          ),
        ],
      ),
    );
  }
}

class _RequestsCount extends StatelessWidget {
  final EquipamentoRepository equipamentos;

  const _RequestsCount({required this.equipamentos});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: equipamentos.requestCollection?.snapshots(),
      builder: (context, snapshot) {
        final int count = snapshot.data?.size ?? 0;
        final bool hasRequests = count > 0;
        final Color color = hasRequests
            ? AppColors.mainColor
            : AppColors.greyColor;

        final String label = switch (count) {
          0 => 'Nenhuma solicitação',
          1 => '1 solicitação de aluguel',
          _ => '$count solicitações de aluguel',
        };

        return Row(
          spacing: 5,
          children: [
            Icon(
              hasRequests
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_none_rounded,
              size: 16,
              color: color,
            ),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: .ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  color: color,
                  fontWeight: hasRequests ? .w600 : .w400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
