import 'package:agroshare/navigator/navigator_app.dart';
import 'package:agroshare/repository/equipamento/equipamento_repository.dart';
import 'package:agroshare/repository/users/users_repository.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/pages/info_anuncio_page.dart';
import 'package:flutter/material.dart';

class BoxHomeAnuncio extends StatelessWidget {
  final EquipamentoRepository equipamentos;
  final UsersRepository? currentUser;
  final double? distanceKm;

  const new({
    super.key,
    required this.equipamentos,
    this.distanceKm,
    this.currentUser,
  });

  static const int _newAnuncioDays = 7;
  static const double _nearKm = 5;

  bool get _isNear => distanceKm != null && distanceKm! <= _nearKm;

  bool get _isNew {
    final DateTime created = DateTime.fromMillisecondsSinceEpoch(
      equipamentos.timestamp,
    );
    return DateTime.now().difference(created).inDays < _newAnuncioDays;
  }

  String? get _distanceLabel {
    if (distanceKm == null) return null;
    if (_isNear) return 'Próximo de você';
    return '${distanceKm!.toStringAsFixed(1).replaceAll('.', ',')} km';
  }

  String get _periodLabel {
    final String days = equipamentos.periodDias;
    return days == '1' ? '1 dia' : '$days dias';
  }

  @override
  Widget build(BuildContext context) {
    final String? distanceLabel = _distanceLabel;

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
          onTap: !equipamentos.status
              ? null
              : () async {
                  final InfoAnuncioPage info = InfoAnuncioPage(
                    currentUser: currentUser,
                    equipamentos: equipamentos,
                    distanceKm: distanceKm,
                  );

                  await NavigatorsApp.push(context, info);
                },
          child: Padding(
            padding: .all(10),
            child: Row(
              spacing: 12,
              children: [
                _Thumbnail(
                  url: equipamentos.images.isNotEmpty
                      ? equipamentos.images.first as String
                      : null,
                  isNew: _isNew,
                  isAvailable: equipamentos.status,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 4,
                    children: [
                      Row(
                        spacing: 8,
                        crossAxisAlignment: .start,
                        children: [
                          Expanded(
                            child: Text(
                              equipamentos.nomeEquipamento,
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: .w700,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                          _StatusBadge(isAvailable: equipamentos.status),
                        ],
                      ),
                      Text(
                        '${equipamentos.nameProperty} · ${equipamentos.name}',
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.greyColor,
                        ),
                      ),
                      Wrap(
                        spacing: 12,
                        runSpacing: 2,
                        children: [
                          if (distanceLabel != null)
                            _MetaItem(
                              icon: Icons.location_on_outlined,
                              label: distanceLabel,
                              color: _isNear ? AppColors.mainColor : null,
                            ),
                          _MetaItem(
                            icon: Icons.calendar_today_outlined,
                            label: _periodLabel,
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(
                            equipamentos.price,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: .w700,
                              color: AppColors.mainColor,
                            ),
                          ),
                          if (equipamentos.status)
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors.greyColor,
                              size: 14,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final String? url;
  final bool isNew;
  final bool isAvailable;

  const _Thumbnail({
    required this.url,
    required this.isNew,
    required this.isAvailable,
  });

  static const double _size = 92;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: .circular(10),
      child: SizedBox(
        height: _size,
        width: _size,
        child: Stack(
          fit: .expand,
          children: [
            if (url == null)
              const _ThumbnailPlaceholder()
            else
              Opacity(
                opacity: isAvailable ? 1 : 0.5,
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
            if (isNew)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: .symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: .circular(6),
                  ),
                  child: Text(
                    'Novo',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: .w700,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
          ],
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
        size: 34,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isAvailable;

  const _StatusBadge({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    final Color color = isAvailable
        ? AppColors.mainColor
        : const Color(0xffB9770E);

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
            isAvailable ? 'Disponível' : 'Indisponível',
            style: TextStyle(fontSize: 11, color: color, fontWeight: .w600),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _MetaItem({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final Color itemColor = color ?? AppColors.greyColor;

    return Row(
      mainAxisSize: .min,
      spacing: 3,
      children: [
        Icon(icon, size: 14, color: itemColor),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            color: itemColor,
            fontWeight: color != null ? .w600 : .w400,
          ),
        ),
      ],
    );
  }
}
