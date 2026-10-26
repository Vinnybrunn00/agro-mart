import 'package:agroshare/features/equipment/data/my_equipment_stream.dart';
import 'package:agroshare/features/equipment/models/equipment_model.dart';
import 'package:agroshare/features/equipment/ui/widgets/my_equipment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyEquipmentTab extends StatelessWidget {
  new({super.key});

  final MyEquipmentStream _ferramentaStream = MyEquipmentStream();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: StreamBuilder(
            stream: _ferramentaStream.equipamentoSnapshot(),
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

                  final EquipmentModel equipamentoRepository =
                      EquipmentModel.fromQueryDocument(
                        queryEquipamentos,
                      );

                  return MyEquipmentCard(
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
