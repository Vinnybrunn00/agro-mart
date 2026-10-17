
import 'dart:io';

import 'package:agroshare/core/streams/user_stream.dart';
import 'package:agroshare/models/equipamentos/days.dart';
import 'package:agroshare/models/equipamentos/description.dart';
import 'package:agroshare/models/equipamentos/equipamentos_model.dart';
import 'package:agroshare/models/equipamentos/images.dart';
import 'package:agroshare/models/equipamentos/name_equipamento.dart';
import 'package:agroshare/models/equipamentos/price.dart';
import 'package:agroshare/core/providers/navigator/navigator_provider.dart';
import 'package:agroshare/repository/product_repository.dart';
import 'package:agroshare/core/providers/location/location_services.dart';
import 'package:agroshare/core/providers/select_images.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/components/shimmer_loading_app.dart';
import 'package:agroshare/ui/input/input.dart';
import 'package:agroshare/utils/utils.dart';
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
              InputText(
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
    final NavigatorProvider navigator = Provider.of<NavigatorProvider>(context);
    return Scaffold(
      appBar: _showAppBar(navigator.index),
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: _NavigatorButtons(),
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
    backgroundColor: AppColors.backgroundColorWhite,
    context: context,
    builder: (ctx) {
      final ImagesEquipamento imagesEquipamento =
          Provider.of<ImagesEquipamento>(context);
      final ProductRepository productRepository =
          Provider.of<ProductRepository>(context);

      return Consumer6<
        ImageManager,
        EquipamentosModel,
        NameEquipamento,
        PriceEquipamento,
        DaysEquipamento,
        DescriptionEquipamento
      >(
        builder:
            (
              context,
              imageManager,
              equipamentos,
              nameEquipamento,
              priceEquipamento,
              daysEquipamento,
              descriptionEquipamento,
              _,
            ) {
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
                                  border: Border.all(
                                    color: AppColors.borderColor,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(BoxIcons.bx_x, size: 20),
                                ),
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
                              onTap: () async =>
                                  await imageManager.onSelectImages(),
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
                                  children: imageManager.listImages
                                      .asMap()
                                      .entries
                                      .map((entry) {
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
                                                  borderRadius: .circular(
                                                    30 / 2,
                                                  ),
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
                                                      .onRemoveImages(
                                                        entry.key,
                                                      ),
                                                  child: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: Colors.black,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                    child: Icon(
                                                      BoxIcons.bx_x,
                                                      color:
                                                          AppColors.whiteColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                      .toList(),
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

                        InputText(
                          onChanged: (name) => equipamentos.name = name,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: .circular(12),
                          ),
                          prefixIcon: BoxIcons.bx_edit_alt,
                          hintText: "Nome do Equipamento",
                          errorText: nameEquipamento.msgError,
                        ),

                        InputText(
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

                        InputText(
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

                        InputText(
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

                        _SubmitEquipamentosBtn(
                          onTap: () async {
                            nameEquipamento.validate(equipamentos.name);
                            priceEquipamento.validate(equipamentos.price);
                            daysEquipamento.validate(equipamentos.periodDays);
                            descriptionEquipamento.validate(
                              equipamentos.description,
                            );
                            imagesEquipamento.validate(imageManager.listImages);

                            await productRepository.saveProduct(
                              equipamentos,
                              imageManager,
                            );

                            if (!context.mounted) return;

                            await Navigator.of(context).maybePop();

                            if (!context.mounted) return;

                            Utils.showMessage(
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
    },
  );
}

class _NavigatorButtons extends StatelessWidget {
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
        child: Consumer<NavigatorProvider>(
          builder: (_, NavigatorProvider navigator, _) {
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

class _SubmitEquipamentosBtn extends StatelessWidget {
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
