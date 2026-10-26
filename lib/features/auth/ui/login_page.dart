//  login_page.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 05/09/2026
//

import 'package:agroshare/features/auth/form/fields/email_field.dart';
import 'package:agroshare/features/auth/form/fields/password_field.dart';
import 'package:agroshare/features/auth/form/auth_form.dart';
import 'package:agroshare/core/navigation/app_navigator.dart';
import 'package:agroshare/features/auth/services/auth_service.dart';
import 'package:agroshare/core/theme/app_colors.dart';
import 'package:agroshare/core/widgets/app_text_field.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_background.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_card.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_button.dart';
import 'package:agroshare/features/auth/ui/register/register_name_page.dart';
import 'package:agroshare/features/home/ui/main_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final EmailField email = Provider.of<EmailField>(context);
    final PasswordField password = Provider.of<PasswordField>(context);
    final AuthForm userModelProvider = Provider.of<AuthForm>(context);
    final AuthService authServices = Provider.of<AuthService>(context);
    return Scaffold(
      body: AuthBackground(
        children: [
          AuthCard(
            spacing: 12,
            children: [
              Column(
                spacing: 10,
                children: [
                  // ICONE
                  _BoxIcon(),

                  // TEXT - ENTRAR
                  _AuthText(),
                ],
              ),

              // EMAIL
              AppTextField(
                prefixIcon: EvaIcons.email_outline,
                hintText: 'Email',
                keyboardType: .emailAddress,
                onChanged: (email) => userModelProvider.email = email,
                errorText: authServices.firebaseMsgError ?? email.msgError,
              ),

              // SENHA
              AppTextField(
                prefixIcon: Icons.key,
                hintText: 'Senha',
                keyboardType: .text,
                onChanged: (password) => userModelProvider.password = password,
                errorText: authServices.firebaseMsgError ?? password.msgError,
              ),

              // ESQUECEU A SENHA
              _ForgetPassword(userModelProvider: userModelProvider),

              // BOTÃO DE ENTRAR
              AuthButton(
                userModelProvider: userModelProvider,
                title: 'Entrar',
                onTap: userModelProvider.isLoading
                    ? null
                    : () async {
                        email.validate(userModelProvider.email);
                        password.validate(userModelProvider.password);

                        if (email.getValue != null &&
                            password.getValue != null) {
                          await authServices.signIn(
                            email: email.getValue!,
                            password: password.getValue!,
                            userModel: userModelProvider,
                          );

                          if (!context.mounted) return;
                          await AppNavigator.push(context, MainShellPage());
                        }
                      },
              ),

              Row(
                spacing: 4,
                mainAxisAlignment: .center,
                children: [
                  Text('Não tem conta?'),
                  GestureDetector(
                    onTap: userModelProvider.isLoading
                        ? null
                        : () async {
                            await AppNavigator.push(context, RegisterNamePage());
                          },
                    child: Text(
                      'Cadastre-se',
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontWeight: .w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// esta classe serve para mostrar o icone do aplicativo na tela de login
class _BoxIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 85,
        width: 85,
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(42.5 / 2),
        ),
        child: Center(child: Image.asset('assets/icons/icon.png', width: 65)),
      ),
    );
  }
}

class _ForgetPassword extends StatelessWidget {
  final AuthForm _userModelProvider;

  const _ForgetPassword({required this._userModelProvider});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _userModelProvider.isLoading ? null : () {},
      child: Text(
        'Esqueceu a senha?',
        style: TextStyle(color: AppColors.mainColor),
      ),
    );
  }
}

class _AuthText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Entrar no AgroShare',
      style: TextStyle(
        fontSize: 18,
        color: AppColors.textColor,
        fontWeight: .w600,
      ),
    );
  }
}
