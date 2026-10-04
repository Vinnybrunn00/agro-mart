import 'dart:developer';

import 'package:agroshare/core/streams/user_stream.dart';
import 'package:agroshare/repository/users/users_repository.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/components/box_anuncio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
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

              final UsersRepository currentUser =
                  UsersRepository.fromQueryDocument(
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

                      final double distanceKm =
                          Geolocator.distanceBetween(
                            currentUser.latitude,
                            currentUser.longitude,
                            queryEquipamentos?['lat'],
                            queryEquipamentos?['long'],
                          ) /
                          1000;

                      final bool isNotView =
                          currentUser.id == queryEquipamentos?['uid'];

                      return (isNotView || distanceKm >= 160)
                          ? SizedBox.shrink()
                          : BoxAnuncio(
                              equipamentos: queryEquipamentos,
                              distanceKm: distanceKm,
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
