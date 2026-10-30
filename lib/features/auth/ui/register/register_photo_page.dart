//  register_photo_page.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 06/09/2026
//

import 'package:agroshare/features/auth/form/auth_form.dart';
import 'package:agroshare/core/navigation/app_navigator.dart';
import 'package:agroshare/features/auth/services/auth_service.dart';
import 'package:agroshare/features/auth/providers/profile_photo_picker.dart';
import 'package:agroshare/core/theme/app_colors.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_back_button.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_background.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_card.dart';
import 'package:agroshare/features/home/ui/main_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class RegisterPhotoPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: .startTop,
      floatingActionButton: AuthBackButton(),
      body: AuthBackground(
        children: [
          AuthCard(
            crossAxisAlignment: .center,
            children: [
              Column(
                spacing: 8,
                children: [
                  // ETAPA
                  Text(
                    'ÚLTIMA ETAPA',
                    style: TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 11,
                      fontWeight: .w700,
                      letterSpacing: 1.1,
                    ),
                  ),

                  // TITULO
                  Text(
                    'Adicione uma foto de perfil',
                    textAlign: .center,
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.textColor,
                      fontWeight: .w700,
                    ),
                  ),

                  // SUBTITULO
                  Text(
                    'Ajude outros produtores a te reconhecer no AgroShare',
                    textAlign: .center,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.4,
                      color: AppColors.greyColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 28),

              // AVATAR
              _AvatarPicker(),

              SizedBox(height: 32),

              // CONTINUAR
              _CreateAccount(),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePhotoPicker>(
      builder: (_, picker, _) {
        return InkWell(
          customBorder: CircleBorder(),
          onTap: () async => await picker.handlePicker(),
          child: Ink(
            height: 140,
            width: 140,
            padding: .all(4),
            decoration: BoxDecoration(
              shape: .circle,
              border: Border.all(
                color: AppColors.mainColor.withAlpha(60),
                width: 2,
              ),
            ),
            child: Stack(
              clipBehavior: .none,
              children: [
                // CIRCULO PLACEHOLDER
                CircleAvatar(
                  maxRadius: 140,
                  backgroundColor: AppColors.mainColor.withAlpha(18),
                  backgroundImage: picker.image != null
                      ? FileImage(picker.image!)
                      : null,
                  child: picker.image != null
                      ? null
                      : Icon(
                          Iconsax.user_outline,
                          size: 62,
                          color: AppColors.mainColor,
                        ),
                ),

                // BADGE DA CAMERA
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: .circle,
                      color: AppColors.mainColor,
                      border: Border.all(color: AppColors.whiteColor, width: 3),
                    ),
                    child: Icon(
                      Iconsax.camera_outline,
                      size: 17,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CreateAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer3<ProfilePhotoPicker, AuthForm, AuthService>(
      builder: (_, picker, userModelProvider, authService, _) {
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: picker.image != null
                ? () async {
                    userModelProvider.image = picker.image;

                    await authService.signUp(userModel: userModelProvider);

                    if (!context.mounted) return;

                    await AppNavigator.pushAndRemoveUntil(
                      context,
                      MainShellPage(),
                    );
                  }
                : null,
            child: Ink(
              height: 52,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.mainColor.withAlpha(
                  picker.image != null ? 255 : 150,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  if (picker.image != null)
                    BoxShadow(
                      color: AppColors.mainColor.withAlpha(90),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                ],
              ),
              child: Center(
                child: userModelProvider.isLoading
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: AppColors.whiteColor,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Concluir cadastro',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 15,
                          fontWeight: .w600,
                          letterSpacing: 0.3,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
