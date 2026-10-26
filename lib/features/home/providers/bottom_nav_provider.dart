import 'package:agroshare/features/chat/ui/conversations_tab.dart';
import 'package:agroshare/features/equipment/ui/my_equipment_tab.dart';
import 'package:agroshare/features/home/ui/home_tab.dart';
import 'package:agroshare/features/profile/ui/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';

class BottomNavProvider with ChangeNotifier {
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
      'screen': HomeTab(),
    },

    {
      'SelectIcon': Iconsax.truck_bold,
      'icon': Iconsax.truck_outline,
      'title': 'Anuncios',
      'screen': MyEquipmentTab(),
    },

    {
      'SelectIcon': Iconsax.messages_2_bold,
      'icon': Iconsax.messages_2_outline,
      'title': 'Conversas',
      'screen': ConversationsTab(),
      // mostra o contador de conversas não lidas
      'badge': true,
    },

    {
      'SelectIcon': Iconsax.user_bold,
      'icon': Iconsax.user_outline,
      'title': 'Conta',
      'screen': ProfileTab(),
    },

    {'icon': Iconsax.add_outline, 'title': 'Criar'},
  ];
}
