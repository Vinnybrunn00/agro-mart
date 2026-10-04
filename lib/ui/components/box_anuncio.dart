import 'package:agroshare/repository/users/users_repository.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class BoxAnuncio extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>>? equipamentos;
  final double? distanceKm;

  const new({
    super.key,
    required this.equipamentos,
    this.distanceKm,
  });

  String _convertCentInReais(int cent) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    double real = cent / 100;
    return formatter.format(real);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .only(left: 12, right: 12),
      margin: .only(left: 16, right: 16),
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: .circular(12),
      ),
      child: Row(
        spacing: 8,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: AppColors.mainColor.withAlpha(80),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.agriculture_outlined),
          ),

          Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .center,
            children: [
              Text(
                equipamentos?['nome_equipamento'],
                style: TextStyle(fontSize: 17, fontWeight: .w600),
              ),
              Row(
                children: [
                  Text('${equipamentos?['name']} · '),

                  if (distanceKm != null)
                    Text(
                      distanceKm! <= 5
                          ? 'Proximo de você'
                          : '${distanceKm!.toStringAsFixed(1)} km',
                      style: TextStyle(
                        color: distanceKm! <= 5 ? AppColors.mainColor : null,
                      ),
                    ),
                ],
              ),

              Text(
                _convertCentInReais(equipamentos?['price']),
                style: TextStyle(fontSize: 15, fontWeight: .w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
