import 'package:agroshare/ui/screens/ferramenta_screen.dart';
import 'package:agroshare/ui/screens/home_screen.dart';
import 'package:agroshare/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';

class NavigatorProvider with ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void changePage(int index) {
    _index = index;
    notifyListeners();
  }

  int get length => screens.length;

  List<Map<String, dynamic>> screens = [
    {
      'SelectIcon': Iconsax.home_2_bold,
      'icon': Iconsax.home_2_outline,
      'title': 'Início',
      'screen': HomeScreen(),
    },

    {
      'SelectIcon': Iconsax.truck_bold,
      'icon': Iconsax.truck_outline,
      'title': 'Anuncios',
      'screen': FerramentaScreen(),
    },

    {
      'SelectIcon': Iconsax.user_bold,
      'icon': Iconsax.user_outline,
      'title': 'Conta',
      'screen': ProfileScreen(),
    },

    {'icon': Iconsax.add_outline, 'title': 'Criar'},
  ];
}
