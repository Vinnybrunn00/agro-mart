//  auth_page.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 05/09/2026
//

import 'package:agroshare/models/auth/credentials/email.dart';
import 'package:agroshare/models/auth/credentials/password.dart';
import 'package:agroshare/models/auth/user_model.dart';
import 'package:agroshare/navigator/navigator_app.dart';
import 'package:agroshare/services/auth/auth_services.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/input/input.dart';
import 'package:agroshare/ui/pages/auth/components/background_auth.dart';
import 'package:agroshare/ui/pages/auth/components/card_auth.dart';
import 'package:agroshare/ui/pages/auth/components/event_button.dart';
import 'package:agroshare/ui/pages/auth/register/name_page.dart';
import 'package:agroshare/ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final Email email = Provider.of<Email>(context);
    final Password password = Provider.of<Password>(context);
    final UserModel userModelProvider = Provider.of<UserModel>(context);
    final AuthServices authServices = Provider.of<AuthServices>(context);
    return Scaffold(
      body: BackgroundAuth(
        children: [
          CardAuth(
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
              InputText(
                prefixIcon: EvaIcons.email_outline,
                hintText: 'Email',
                keyboardType: .emailAddress,
                onChanged: (email) => userModelProvider.email = email,
                errorText: authServices.firebaseMsgError ?? email.msgError,
              ),

              // SENHA
              InputText(
                prefixIcon: Icons.key,
                hintText: 'Senha',
                keyboardType: .text,
                onChanged: (password) => userModelProvider.password = password,
                errorText: authServices.firebaseMsgError ?? password.msgError,
              ),

              // ESQUECEU A SENHA
              _ForgetPassword(userModelProvider: userModelProvider),

              // BOTÃO DE ENTRAR
              EventButton(
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
                          await NavigatorsApp.push(context, HomePage());
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
                            await NavigatorsApp.push(context, NamePage());
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
  final UserModel _userModelProvider;

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
