import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 12,
        children: [
          for (int i = 0; i < 10; i++)
            Container(
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
                        'Trator Massey 4x2 65cv',
                        style: TextStyle(fontSize: 15, fontWeight: .w600),
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Text('João P. · 3,2 km'),
                          Row(
                            spacing: 5,
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              Text('4.9'),
                            ],
                          ),
                        ],
                      ),

                      Text(
                        'R\$ 180,00',
                        style: TextStyle(fontSize: 15, fontWeight: .w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
