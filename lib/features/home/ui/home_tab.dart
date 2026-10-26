import 'dart:developer';

import 'package:agroshare/features/profile/data/user_stream.dart';
import 'package:agroshare/features/equipment/models/equipment_model.dart';
import 'package:agroshare/features/profile/models/user_model.dart';
import 'package:agroshare/features/equipment/ui/widgets/equipment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeTab extends StatelessWidget {
  new({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final UserStream _userStream = UserStream();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        Expanded(
          child: StreamBuilder(
            stream: _userStream.snapshot(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return Text('Error');
              }

              final UserModel currentUser =
                  UserModel.fromQueryDocument(
                    queryDocument: userSnapshot.data!,
                  );

              return StreamBuilder(
                stream: _firestore.collectionGroup('equipamentos').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) return Text('Error');

                  final equipamentos = snapshot.data?.docs;

                  return ListView.builder(
                    itemCount: equipamentos?.length,
                    itemBuilder: (context, index) {
                      final queryEquipamentos = equipamentos?[index];

                      final EquipmentModel equipamentoRepository =
                          EquipmentModel.fromQueryDocument(
                            queryEquipamentos,
                          );

                      final double distanceKm =
                          Geolocator.distanceBetween(
                            currentUser.latitude,
                            currentUser.longitude,
                            equipamentoRepository.lat,
                            equipamentoRepository.long,
                          ) /
                          1000;

                      final bool isNotView =
                          currentUser.id == equipamentoRepository.uid;

                      if (equipamentoRepository.accept) {
                        return SizedBox.shrink();
                      }

                      if (isNotView) {
                        return SizedBox.shrink();
                      }

                      // O documento do pedido é salvo com o id do usuário
                      // (requests/{userId}), então basta checar se ele existe.
                      final requests = queryEquipamentos?.reference
                          .collection('requests')
                          .doc(currentUser.id);

                      return StreamBuilder<
                        DocumentSnapshot<Map<String, dynamic>>
                      >(
                        stream: requests?.snapshots(),
                        builder: (context, requestSnapshot) {
                          final bool hasRequest =
                              requestSnapshot.data?.exists ?? false;

                          if (hasRequest) {
                            return SizedBox.shrink();
                          }

                          return EquipmentCard(
                            currentUser: currentUser,
                            equipamentos: equipamentoRepository,
                            distanceKm: distanceKm,
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
