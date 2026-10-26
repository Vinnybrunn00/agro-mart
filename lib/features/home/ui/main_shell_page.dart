import 'dart:io';

import 'package:agroshare/features/chat/providers/conversations_provider.dart';
import 'package:agroshare/features/profile/data/user_stream.dart';
import 'package:agroshare/features/equipment/form/fields/equipment_days_field.dart';
import 'package:agroshare/features/equipment/form/fields/equipment_description_field.dart';
import 'package:agroshare/features/equipment/form/equipment_form.dart';
import 'package:agroshare/features/equipment/form/fields/equipment_images_field.dart';
import 'package:agroshare/features/equipment/form/fields/equipment_name_field.dart';
import 'package:agroshare/features/equipment/form/fields/equipment_price_field.dart';
import 'package:agroshare/features/home/providers/bottom_nav_provider.dart';
import 'package:agroshare/features/equipment/providers/create_equipment_provider.dart';
import 'package:agroshare/features/equipment/providers/equipment_image_picker.dart';
import 'package:agroshare/core/theme/app_colors.dart';
import 'package:agroshare/core/widgets/shimmer_loading.dart';
import 'package:agroshare/core/widgets/app_text_field.dart';
import 'package:agroshare/core/utils/app_messenger.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class MainShellPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return _MainShell();
  }
}

class _MainShell extends StatelessWidget {
  final UserStream _userStream = UserStream();

  PreferredSizeWidget? _showAppBar(int index) {
    switch (index) {
      case 0:
        return PreferredSize(
          preferredSize: Size(double.infinity, 110),
          child: Column(
            children: [
              AppBar(
                scrolledUnderElevation: 0,
                backgroundColor: AppColors.backgroundColor,
                title: StreamBuilder(
                  stream: _userStream.snapshot(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ShimmerLoading(width: 130);
                    }

                    final Map<String, dynamic>? data = snapshot.data?.data();

                    return Text(
                      'Olá, ${data?['name'].toString()}',
                      style: TextStyle(fontSize: 18),
                    );
                  },
                ),
              ),
              AppTextField(
                autoFocus: false,
                padding: .only(left: 12, right: 12),
                prefixIcon: BoxIcons.bx_search,
              ),
            ],
          ),
        );
      case 1:
        return AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.backgroundColor,
          title: Text(
            'Minhas Ferramentas',
            style: TextStyle(
              fontSize: 22,
              color: AppColors.textColor,
              fontWeight: .w700,
            ),
          ),
        );
      case 2:
        return AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.backgroundColor,
          title: Text(
            'Conversas',
            style: TextStyle(
              fontSize: 22,
              color: AppColors.textColor,
              fontWeight: .w700,
            ),
          ),
        );
      case 3:
        return AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.backgroundColor,
          title: Text(
            'Conta',
            style: TextStyle(
              fontSize: 22,
              color: AppColors.textColor,
              fontWeight: .w700,
            ),
          ),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavProvider navigator = Provider.of<BottomNavProvider>(context);
    return Scaffold(
      appBar: _showAppBar(navigator.index),
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: _BottomNavBar(),
      body: SafeArea(child: navigator.screens[navigator.index]['screen']),
    );
  }
}

Future<void> _addEquipamento(BuildContext context) async {
  await showModalBottomSheet(
    sheetAnimationStyle: AnimationStyle(
      duration: Duration(milliseconds: 450),
      curve: Curves.fastOutSlowIn,
    ),
    useSafeArea: true,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: AppColors.backgroundColor,
    context: context,
    builder: (_) {
      final EquipmentImagesField imagesEquipamento =
          Provider.of<EquipmentImagesField>(context);

      final CreateEquipmentProvider productRepository =
          Provider.of<CreateEquipmentProvider>(context);

      final EquipmentImagePicker imageManager = Provider.of<EquipmentImagePicker>(context);

      final EquipmentForm equipamentos = Provider.of<EquipmentForm>(
        context,
      );
      final EquipmentNameField nameEquipamento = Provider.of<EquipmentNameField>(
        context,
      );
      final EquipmentPriceField priceEquipamento = Provider.of<EquipmentPriceField>(
        context,
      );
      final EquipmentDaysField daysEquipamento = Provider.of<EquipmentDaysField>(
        context,
      );
      final EquipmentDescriptionField descriptionEquipamento =
          Provider.of<EquipmentDescriptionField>(context);

      return Stack(
        children: [
          Container(
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

                Row(
                  spacing: 5,
                  children: [
                    GestureDetector(
                      onTap: () async => await imageManager.onSelectImages(),
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          dashPattern: [8, 4],
                          strokeWidth: 1,
                          radius: Radius.circular(30 / 2),
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
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: .horizontal,
                        child: Row(
                          children: imageManager.listImages.asMap().entries.map(
                            (entry) {
                              return Container(
                                alignment: .center,
                                height: 85,
                                width: 80,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    SizedBox(
                                      height: 70,
                                      width: 70,
                                      child: ClipRRect(
                                        borderRadius: .circular(30 / 2),
                                        child: Image.file(
                                          File(entry.value),
                                          width: 10,
                                          fit: .cover,
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      top: -5,
                                      right: -5,
                                      child: GestureDetector(
                                        onTap: () => imageManager
                                            .onRemoveImages(entry.key),
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            BoxIcons.bx_x,
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ],
                ),

                if (imageManager.isNotEmpty) ...[
                  if (imageManager.length > 1)
                    Text('${imageManager.length} selecionadas.')
                  else
                    Text('${imageManager.length} selecionada.'),
                ],

                Divider(),

                AppTextField(
                  onChanged: (name) => equipamentos.name = name,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: .circular(12),
                  ),
                  prefixIcon: BoxIcons.bx_edit_alt,
                  hintText: "Nome do Equipamento",
                  errorText: nameEquipamento.msgError,
                ),

                AppTextField(
                  onChanged: (price) => equipamentos.price = price,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: .circular(12),
                  ),
                  prefixIcon: BoxIcons.bx_purchase_tag,
                  hintText: "Preço (R\$)",
                  keyboardType: .number,
                  inputFormatters: [equipamentos.formatter],
                  errorText: priceEquipamento.msgError,
                ),

                AppTextField(
                  onChanged: (days) => equipamentos.periodDays = days,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: .circular(12),
                  ),
                  prefixIcon: BoxIcons.bx_calendar,
                  hintText: "Período de aluguel em dias. (ex: 30)",
                  keyboardType: .number,
                  errorText: daysEquipamento.msgError,
                ),

                AppTextField(
                  onChanged: (description) =>
                      equipamentos.description = description,
                  height: 150,
                  maxLines: null,
                  expands: true,
                  maxLength: 300,
                  autoFocus: false,
                  keyboardType: .multiline,
                  textCapitalization: .sentences,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: .circular(12),
                  ),
                  hintText: "Descrição do Equipamento",
                  errorText: descriptionEquipamento.msgError,
                ),

                _SubmitEquipmentButton(
                  onTap: () async {
                    nameEquipamento.validate(equipamentos.name);
                    priceEquipamento.validate(equipamentos.price);
                    daysEquipamento.validate(equipamentos.periodDays);
                    descriptionEquipamento.validate(equipamentos.description);
                    imagesEquipamento.validate(imageManager.listImages);

                    await productRepository.saveEquipment(
                      equipamentos,
                      imageManager,
                    );

                    if (!context.mounted) return;

                    await Navigator.of(context).maybePop();

                    if (!context.mounted) return;

                    AppMessenger.showMessage(
                      context,
                      message: 'Ferramenta publicada com sucesso!',
                    );

                    if (imageManager.listImages.isNotEmpty) {
                      imageManager.clearImages();
                    }
                  },
                ),
              ],
            ),
          ),

          if (productRepository.isLoading)
            Container(
              color: Colors.black.withAlpha(75),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(22),
                  height: 82,
                  width: 82,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: CircularProgressIndicator(
                    color: AppColors.mainColor,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        margin: .only(top: 8, left: 12, right: 12, bottom: 8),
        duration: Duration(milliseconds: 450),
        height: 65,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Consumer2<BottomNavProvider, ConversationsProvider>(
          builder: (_, BottomNavProvider navigator, conversas, _) {
            return Row(
              mainAxisAlignment: .spaceEvenly,
              children: navigator.screens.asMap().entries.map((entry) {
                final Map<String, dynamic> value = entry.value;
                final int index = entry.key;

                final bool selected = navigator.index == index;

                final bool isAdd = value['screen'] == null;

                return _BottomNavItem(
                  iconColor: selected ? AppColors.mainColor : null,
                  icon: selected ? value['SelectIcon'] : value['icon'],
                  title: value['title'],
                  badge: value['badge'] == true ? conversas.unreadCount : 0,
                  onTap: isAdd
                      ? () async => await _addEquipamento(context)
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

class _BottomNavItem extends StatelessWidget {
  final IconData? _icon;
  final String _title;
  final void Function()? _onTap;
  final Color? _iconColor;
  final int _badge;

  const _BottomNavItem({
    required this._onTap,
    required this._icon,
    required this._title,
    required this._iconColor,
    this._badge = 0,
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
                Badge(
                  isLabelVisible: _badge > 0,
                  label: Text(_badge > 9 ? '9+' : '$_badge'),
                  backgroundColor: Colors.redAccent,
                  textColor: AppColors.whiteColor,
                  offset: Offset(8, -6),
                  child: Icon(
                    _icon,
                    color: _iconColor ?? Color(0xCD5B6058),
                    size: 19,
                  ),
                ),
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

class _SubmitEquipmentButton extends StatelessWidget {
  final void Function()? onTap;

  const new({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(12),
      child: Ink(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: .circular(12),
        ),
        child: Center(
          child: Text(
            'Anunciar Equipamento',
            style: TextStyle(color: AppColors.whiteColor, fontWeight: .w600),
          ),
        ),
      ),
    );
  }
}
