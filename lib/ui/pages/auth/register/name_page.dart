import 'package:agroshare/models/auth/credentials/name.dart';
import 'package:agroshare/models/auth/user_model.dart';
import 'package:agroshare/navigator/navigator_app.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/input/input.dart';
import 'package:agroshare/ui/pages/auth/components/background_auth.dart';
import 'package:agroshare/ui/pages/auth/components/card_auth.dart';
import 'package:agroshare/ui/pages/auth/components/event_button.dart';
import 'package:agroshare/ui/pages/auth/register/cpf_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class NamePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel userModelProvider = Provider.of<UserModel>(context);
    final Name name = Provider.of<Name>(context);
    return Scaffold(
      floatingActionButtonLocation: .startTop,
      floatingActionButton: Padding(
        padding: .only(left: 5, top: 20),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(BoxIcons.bx_arrow_back, color: AppColors.whiteColor),
        ),
      ),
      body: BackgroundAuth(
        children: [
          CardAuth(
            children: [
              Text(
                'Seu nome completo',
                style: TextStyle(
                  color: Color(0xFF111540),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Preencha abaixo com o seu nome completo',
                style: TextStyle(color: AppColors.greyColor, fontSize: 13),
              ),
              SizedBox(height: 15),
              InputText(
                prefixIcon: BoxIcons.bx_user,
                hintText: 'Nome Completo',
                keyboardType: .text,
                onChanged: (name) => userModelProvider.name = name,
                errorText: name.msgError,
              ),
              SizedBox(height: 12),

              EventButton(
                userModelProvider: userModelProvider,
                onTap: () async {
                  name.validate(userModelProvider.name);
                  if (name.getValue != null) {
                    await NavigatorsApp.push(context, CPFPage());
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
