import 'package:agroshare/repository/equipamento/equipamento_repository.dart';
import 'package:agroshare/ui/components/box_ferramentas_anuncio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FerramentaScreen extends StatelessWidget {
  new({super.key});

  User? get _currentUser => FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: StreamBuilder(
            stream: _firestore
                .collection('users')
                .doc(_currentUser?.uid)
                .collection('equipamentos')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData) return Text('Error');

              final List<QueryDocumentSnapshot<Map<String, dynamic>>>? docs =
                  snapshot.data?.docs;

              if (docs!.isEmpty) {
                return Center(
                  child: Text('Você ainda não anunciou nenhum equipamento'),
                );
              }

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final QueryDocumentSnapshot<Map<String, dynamic>>
                  queryEquipamentos = docs[index];

                  final EquipamentoRepository equipamentoRepository =
                      EquipamentoRepository.fromQueryDocument(
                        queryEquipamentos,
                      );

                  return BoxFerramentasAnuncio(
                    equipamentos: equipamentoRepository,
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
