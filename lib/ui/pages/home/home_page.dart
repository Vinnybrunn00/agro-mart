import 'dart:developer';
import 'dart:ui';

import 'package:agroshare/core/streams/user_stream.dart';
import 'package:agroshare/navigator/navigator_app.dart';
import 'package:agroshare/services/location/location_services.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/components/shimmer_loading_app.dart';
import 'package:agroshare/ui/input/input.dart';
import 'package:agroshare/ui/pages/auth/components/event_button.dart';
import 'package:agroshare/ui/pages/equipamentos_page.dart';
import 'package:agroshare/ui/screens/chat_screen.dart';
import 'package:agroshare/ui/screens/home_screen.dart';
import 'package:agroshare/ui/screens/profile_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  new({super.key});

  final LocationServices _locationServices = LocationServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _locationServices.locationServiceStatusStream,
      builder: (_, snapshot) {
        final bool? status = snapshot.data;

        return MainPage();
      },
    );
  }
}

class MainPage extends StatelessWidget {
  new({super.key});

  final UserStream _userStream = UserStream();

  @override
  Widget build(BuildContext context) {
    final NavigatorProvider navigator = Provider.of<NavigatorProvider>(context);
    return Scaffold(
      floatingActionButton: navigator.index != 0
          ? null
          : GestureDetector(
              onTap: () async =>
                  await NavigatorsApp.push(context, EquipamentosPage()),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: .circular(60 / 2),
                ),
                child: Center(
                  child: Icon(
                    Iconsax.task_outline,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
      appBar: navigator.index != 0
          ? null
          : AppBar(
              backgroundColor: AppColors.backgroundColor,
              title: StreamBuilder(
                stream: _userStream.snapshot(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SimmerLoading(width: 130);
                  }

                  final Map<String, dynamic>? data = snapshot.data?.data();

                  return Text(
                    'Olá, ${data?['name'].toString()}',
                    style: TextStyle(fontSize: 18),
                  );
                },
              ),
            ),
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: _NavigatorButtons(),
      body: SafeArea(child: navigator.screens[navigator.index]['screen']),
    );
  }
}

class ErrorLocation extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: SafeArea(
        child: Padding(
          padding: .symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              // ICONE
              Container(
                height: 96,
                width: 96,
                decoration: BoxDecoration(
                  shape: .circle,
                  color: AppColors.backgroundColorWhite,
                ),
                child: Icon(
                  Iconsax.location_outline,
                  size: 44,
                  color: AppColors.mainColor,
                ),
              ),

              const SizedBox(height: 24),

              // TITULO
              Text(
                'Localização desativada',
                textAlign: .center,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textColor,
                  fontWeight: .w600,
                ),
              ),

              const SizedBox(height: 8),

              // SUBTITULO
              Text(
                'Precisamos da sua localização para mostrar equipamentos e serviços perto de você.',
                textAlign: .center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.blackColorAlpha120,
                ),
              ),

              const SizedBox(height: 32),

              // BOTAO
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    LocationServices locationServices = LocationServices();

                    try {
                      await locationServices.determinePosition();
                    } catch (err) {
                      log(err.toString());
                    }
                  },
                  child: Ink(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Permitir localização',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: .w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigatorButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        margin: .only(left: 12, right: 12, bottom: 18),
        duration: Duration(milliseconds: 450),
        height: 65,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),

        child: Consumer<NavigatorProvider>(
          builder: (_, navigator, _) {
            return Row(
              mainAxisAlignment: .spaceEvenly,
              children: navigator.screens.asMap().entries.map((entry) {
                final Map<String, dynamic> value = entry.value;
                final int index = entry.key;

                final bool selected = navigator.index == index;

                final bool isAdd = value['screen'] == null;

                return _NavigatorApp(
                  iconColor: selected ? AppColors.mainColor : null,
                  icon: selected ? value['SelectIcon'] : value['icon'],
                  title: value['title'],
                  onTap: isAdd
                      ? () async => await _showModal(context)
                      : (selected ? null : () => navigator.changePage(index)),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

Future<void> _showModal(BuildContext context) async {
  await showModalBottomSheet(
    sheetAnimationStyle: AnimationStyle(
      duration: Duration(milliseconds: 450),
      curve: Curves.fastOutSlowIn,
    ),
    useSafeArea: true,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: AppColors.backgroundColorWhite,
    context: context,
    builder: (ctx) {
      return Container(
        padding: .all(12),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          spacing: 8,
          crossAxisAlignment: .start,
          children: [
            Row(
              spacing: 30,
              children: [
                InkWell(
                  borderRadius: .circular(20 / 2),
                  onTap: () => Navigator.pop(context),
                  child: Ink(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: .circular(20 / 2),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Center(child: Icon(BoxIcons.bx_x, size: 20)),
                  ),
                ),

                Text(
                  'Anunciar equipamento',
                  style: TextStyle(fontSize: 18, fontWeight: .w600),
                ),
              ],
            ),

            SizedBox(height: 5),

            DottedBorder(
              options: RoundedRectDottedBorderOptions(
                dashPattern: [8, 4],
                strokeWidth: 1,
                radius: Radius.circular(
                  30 / 2,
                ), // Defina o raio das bordas arredondadas aqui
              ),
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: .circular(30 / 2),
                ),
                child: Center(child: Icon(Icons.add)),
              ),
            ),

            InputText(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(12),
              ),
              prefixIcon: BoxIcons.bx_edit_alt,
              hintText: "Nome do equipamento",
            ),

            InputText(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(12),
              ),
              prefixIcon: BoxIcons.bx_purchase_tag,
              hintText: "Preço (R\$)",
            ),

            InputText(
              color: Colors.transparent,
              height: 150,
              focusedBorder: OutlineInputBorder(),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(12),
              ),
              prefixIcon: BoxIcons.bx_purchase_tag,
              hintText: "Preço (R\$)",
            ),
          ],
        ),
      );
    },
  );
}

class _NavigatorApp extends StatelessWidget {
  final IconData? _icon;
  final String _title;
  final void Function()? _onTap;
  final Color? _iconColor;

  const _NavigatorApp({
    required this._onTap,
    required this._icon,
    required this._title,
    required this._iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        margin: .only(top: 5, bottom: 5),
        child: InkWell(
          onTap: _onTap,
          borderRadius: BorderRadius.circular(25),
          child: Ink(
            width: size.width * .18,
            child: Column(
              spacing: 3,
              mainAxisAlignment: .center,
              children: [
                Icon(_icon, color: _iconColor ?? Color(0xCD5B6058), size: 19),
                Text(
                  _title,
                  style: TextStyle(
                    color: _iconColor ?? Color(0xCD5B6058),
                    fontSize: 12,
                    fontWeight: _iconColor != null ? .w600 : null,
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
      'SelectIcon': Iconsax.message_2_bold,
      'icon': Iconsax.message_2_outline,
      'title': 'Chat',
      'screen': ChatScreen(),
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
