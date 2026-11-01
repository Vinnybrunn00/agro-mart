import 'package:agroshare/core/theme/app_colors.dart';
import 'package:agroshare/core/widgets/shimmer_loading.dart';
import 'package:agroshare/features/profile/data/user_stream.dart';
import 'package:agroshare/features/equipment/models/equipment_model.dart';
import 'package:agroshare/features/profile/models/user_model.dart';
import 'package:agroshare/features/equipment/ui/widgets/equipment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';

class HomeTab extends StatelessWidget {
  new({super.key});

  /// Raio máximo (em km) para exibir anúncios. Anúncios a uma distância
  /// maior ou igual a este valor não são exibidos.
  static const double _maxDistanceKm = 100;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final UserStream _userStream = UserStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userStream.snapshot(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const _HomeLoading();
        }

        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return const _HomeMessage(
            icon: BoxIcons.bx_error_circle,
            title: 'Não foi possível carregar seu perfil',
            message: 'Verifique sua conexão e tente novamente em instantes.',
          );
        }

        final UserModel currentUser = UserModel.fromQueryDocument(
          queryDocument: userSnapshot.data!,
        );

        return StreamBuilder(
          stream: _firestore.collectionGroup('equipamentos').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _HomeLoading();
            }

            if (!snapshot.hasData) {
              return const _HomeMessage(
                icon: BoxIcons.bx_wifi_off,
                title: 'Não foi possível carregar os anúncios',
                message:
                    'Verifique sua conexão e tente novamente em instantes.',
              );
            }

            final List<QueryDocumentSnapshot<Map<String, dynamic>>>?
            equipamentos = snapshot.data?.docs;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _HomeHeader(
                    currentUser: currentUser,
                    radiusKm: _maxDistanceKm,
                  ),
                ),

                SliverList.builder(
                  itemCount: equipamentos?.length,
                  itemBuilder: (context, index) {
                    final queryEquipamentos = equipamentos?[index];

                    final EquipmentModel equipamentoRepository =
                        EquipmentModel.fromQueryDocument(
                          queryEquipamentos,
                          currentUser,
                        );

                    if (equipamentoRepository.accept) {
                      return SizedBox.shrink();
                    }

                    if (equipamentoRepository.isNotView) {
                      return SizedBox.shrink();
                    }

                    if (equipamentoRepository.distanceKm >= _maxDistanceKm) {
                      return SizedBox.shrink();
                    }

                    // O documento do pedido é salvo com o id do usuário
                    // (requests/{userId}), então basta checar se ele existe.
                    final DocumentReference<Map<String, dynamic>>? requests =
                        queryEquipamentos?.reference
                            .collection('requests')
                            .doc(currentUser.id);

                    return StreamBuilder<
                      DocumentSnapshot<Map<String, dynamic>>
                    >(
                      stream: requests?.snapshots(),
                      builder: (context, requestSnapshot) {
                        final bool hasRequest =
                            requestSnapshot.data?.exists ?? false;

                        if (hasRequest) return SizedBox.shrink();

                        return EquipmentCard(
                          currentUser: currentUser,
                          equipamentos: equipamentoRepository,
                        );
                      },
                    );
                  },
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
        );
      },
    );
  }
}

String _formatKm(double km) {
  final String value = km == km.roundToDouble()
      ? km.toStringAsFixed(0)
      : km.toStringAsFixed(1).replaceAll('.', ',');
  return '$value km';
}

/// Cabeçalho da Home: localização de referência, raio de busca e
/// título da seção de anúncios.
class _HomeHeader extends StatelessWidget {
  final UserModel currentUser;
  final double radiusKm;

  const _HomeHeader({required this.currentUser, required this.radiusKm});

  @override
  Widget build(BuildContext context) {
    final String location = currentUser.locationProperty.trim();
    final String property = currentUser.nameProperty.trim();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: .circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.mainColor.withAlpha(45),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 12,
              children: [
                Row(
                  spacing: 12,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor.withAlpha(36),
                        borderRadius: .circular(12),
                      ),
                      child: Icon(
                        BoxIcons.bx_map_pin,
                        color: AppColors.whiteColor,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 2,
                        children: [
                          Text(
                            'Buscando a partir de',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.whiteColor.withAlpha(190),
                            ),
                          ),
                          Text(
                            property.isNotEmpty ? property : 'Sua propriedade',
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: .w700,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          if (location.isNotEmpty)
                            Text(
                              location,
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.whiteColor.withAlpha(190),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withAlpha(28),
                    borderRadius: .circular(10),
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      Icon(
                        BoxIcons.bx_radar,
                        size: 16,
                        color: AppColors.whiteColor,
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.whiteColor.withAlpha(220),
                            ),
                            children: [
                              const TextSpan(text: 'Raio de busca: '),
                              TextSpan(
                                text: 'até ${_formatKm(radiusKm)}',
                                style: TextStyle(
                                  fontWeight: .w700,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Equipamentos disponíveis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: .w700,
              color: AppColors.textColor,
            ),
          ),

          const SizedBox(height: 4),

          Row(
            spacing: 6,
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Icon(
                  BoxIcons.bx_info_circle,
                  size: 14,
                  color: AppColors.greyColor,
                ),
              ),
              Expanded(
                child: Text(
                  'Mostrando anúncios a menos de ${_formatKm(radiusKm)} '
                  'da sua propriedade.',
                  style: TextStyle(fontSize: 12.5, color: AppColors.greyColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Estado de carregamento com skeletons no formato dos cards.
class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      children: [
        ShimmerLoading(height: 112, borderRadius: .circular(16)),
        const SizedBox(height: 20),
        const ShimmerLoading(width: 200, height: 20),
        const SizedBox(height: 4),
        const ShimmerLoading(width: 260, height: 14),
        const SizedBox(height: 10),
        for (int i = 0; i < 4; i++) ...[
          ShimmerLoading(height: 100, borderRadius: .circular(14)),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

/// Estado de erro/aviso centralizado.
class _HomeMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _HomeMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: .min,
          spacing: 8,
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: AppColors.mainColor.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: AppColors.mainColor),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: .center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: .w700,
                color: AppColors.textColor,
              ),
            ),
            Text(
              message,
              textAlign: .center,
              style: TextStyle(fontSize: 13, color: AppColors.greyColor),
            ),
          ],
        ),
      ),
    );
  }
}
