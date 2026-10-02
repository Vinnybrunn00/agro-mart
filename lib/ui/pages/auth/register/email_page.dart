import 'package:agroshare/models/auth/credentials/email.dart';
import 'package:agroshare/models/auth/user_model.dart';
import 'package:agroshare/navigator/navigator_app.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/input/input.dart';
import 'package:agroshare/ui/pages/auth/components/background_auth.dart';
import 'package:agroshare/ui/pages/auth/components/card_auth.dart';
import 'package:agroshare/ui/pages/auth/components/event_button.dart';
import 'package:agroshare/ui/pages/auth/register/password_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class EmailPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel userModelProvider = Provider.of<UserModel>(context);
    final Email email = Provider.of<Email>(context);
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
                'Seu Email',
                style: TextStyle(
                  color: Color(0xFF111540),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Preencha abaixo com o seu Email',
                style: TextStyle(color: AppColors.greyColor, fontSize: 13),
              ),
              SizedBox(height: 15),
              InputText(
                prefixIcon: EvaIcons.email_outline,
                hintText: 'Email',
                keyboardType: .emailAddress,
                onChanged: (email) => userModelProvider.email = email,
                errorText: email.msgError,
              ),

              SizedBox(height: 12),

              EventButton(
                userModelProvider: userModelProvider,
                onTap: () async {
                  email.validate(userModelProvider.email);

                  if (email.getValue != null) {

                    await NavigatorsApp.push(context, PasswordPage());
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
