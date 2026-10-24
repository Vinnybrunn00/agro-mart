//  profile_screen.dart
//  AgroMart
//
//  Create by Vinicius Bruno on 06/09/2026
//

import 'package:agroshare/core/session/app_session.dart';
import 'package:agroshare/core/streams/user_stream.dart';
import 'package:agroshare/models/profile/current_user_model.dart';
import 'package:agroshare/navigator/navigator_app.dart';
import 'package:agroshare/core/providers/picker/picker_profile.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/pages/pedidos_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  new({super.key});

  final UserStream _userStream = UserStream();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: .only(left: 20, right: 20, top: 10, bottom: 30),
      child: StreamBuilder(
        stream: _userStream.snapshot(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LinearProgressIndicator());
          }

          if (!snapshot.hasData) return Text('No Data');

          final Map<String, dynamic>? data = snapshot.data?.data();

          final CurrentUser currentUser = CurrentUser.fromMap(data: data!);

          return Column(
            crossAxisAlignment: .start,
            spacing: 24,
            children: [
              // FOTO E NOME
              _ProfileHeader(currentUser: currentUser),

              // CREDENCIAIS
              Column(
                crossAxisAlignment: .start,
                spacing: 12,
                children: [
                  Text(
                    'Minhas informações',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textColor,
                      fontWeight: .w600,
                    ),
                  ),

                  _CredentialCard(
                    icon: Iconsax.user_outline,
                    label: 'Nome completo',
                    value: currentUser.name,
                  ),

                  _CredentialCard(
                    icon: Iconsax.sms_outline,
                    label: 'E-mail',
                    value: currentUser.email,
                  ),

                  _CredentialCard(
                    icon: Iconsax.personalcard_outline,
                    label: 'CPF',
                    value: currentUser.cpf,
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: .start,
                spacing: 12,
                children: [
                  Text(
                    'Ações',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textColor,
                      fontWeight: .w600,
                    ),
                  ),

                  _CredentialCard(
                    onTap: () async {
                      final PedidosPage pedidosPage = PedidosPage(
                        currentUser: currentUser,
                      );

                      await NavigatorsApp.push(context, pedidosPage);
                    },
                    icon: Iconsax.arrow_2_bold,
                    value: 'Meus pedidos',
                  ),
                ],
              ),

              // BOTÕES
              _ProfileButton(
                icon: Iconsax.logout_outline,
                title: 'Sair da conta',
                color: Colors.redAccent,
                onTap: () async {
                  await FirebaseAuth.instance.signOut();

                  if (!context.mounted) return;

                  // RECRIA PROVIDERS E NAVEGAÇÃO, LIMPANDO OS DADOS DA CONTA
                  AppSession.reset(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final CurrentUser _currentUser;

  const _ProfileHeader({required this._currentUser});

  @override
  Widget build(BuildContext context) {
    return Consumer<PickerProfile>(
      builder: (_, PickerProfile picker, _) {
        return Container(
          width: double.infinity,
          padding: .symmetric(horizontal: 18, vertical: 22),
          decoration: BoxDecoration(
            color: AppColors.backgroundColorCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            spacing: 16,
            children: [
              // AVATAR
              Stack(
                clipBehavior: .none,
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: AppColors.backgroundColorWhite,
                    backgroundImage: picker.image != null
                        ? FileImage(picker.image!)
                        : NetworkImage(_currentUser.photoUrl),
                  ),

                  // BADGE DA CAMERA
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: GestureDetector(
                      onTap: () async => await picker.handlePicker(),
                      child: Container(
                        height: 26,
                        width: 26,
                        decoration: BoxDecoration(
                          shape: .circle,
                          color: AppColors.mainColor,
                          border: Border.all(
                            color: AppColors.whiteColor,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Iconsax.camera_outline,
                          size: 13,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // NOME E EMAIL
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 4,
                  children: [
                    Text(
                      _currentUser.name,
                      overflow: .ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.textColor,
                        fontWeight: .w600,
                      ),
                    ),
                    Text(
                      _currentUser.email,
                      overflow: .ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.blackColorAlpha120,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CredentialCard extends StatelessWidget {
  final IconData _icon;
  final String? _label;
  final String _value;
  final void Function()? onTap;

  const _CredentialCard({
    required this._icon,
    this._label,
    required this._value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        width: double.infinity,
        padding: .symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.backgroundColorCard,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          spacing: 14,
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: .center,
              decoration: BoxDecoration(
                color: AppColors.mainColor.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_icon, size: 19, color: AppColors.mainColor),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 2,
                children: [
                  if (_label != null)
                    Text(
                      _label,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.blackColorAlpha120,
                      ),
                    ),
                  Text(
                    _value,
                    overflow: .ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textColor,
                      fontWeight: .w600,
                    ),
                  ),
                ],
              ),
            ),

            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.greyColor,
                size: 19,
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  final IconData _icon;
  final String _title;
  final Color? _color;
  final void Function()? _onTap;

  const _ProfileButton({
    required this._icon,
    required this._title,
    this._color,
    required this._onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = _color ?? AppColors.mainColor;

    return Material(
      color: AppColors.backgroundColorCard,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _onTap,
        child: Ink(
          width: double.infinity,
          padding: .symmetric(horizontal: 16, vertical: 15),
          child: Row(
            spacing: 14,
            children: [
              Icon(_icon, size: 20, color: color),
              Expanded(
                child: Text(
                  _title,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: .w600,
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
