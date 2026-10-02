import 'package:agroshare/models/auth/credentials/password.dart';
import 'package:agroshare/models/auth/user_model.dart';
import 'package:agroshare/navigator/navigator_app.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/input/input.dart';
import 'package:agroshare/ui/pages/auth/register/add_info_sitio.dart';
import 'package:agroshare/ui/pages/auth/register/add_photo_page.dart';
import 'package:agroshare/ui/pages/auth/components/background_auth.dart';
import 'package:agroshare/ui/pages/auth/components/card_auth.dart';
import 'package:agroshare/ui/pages/auth/components/event_button.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class PasswordPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel userModelProvider = Provider.of<UserModel>(context);
    final Password password = Provider.of<Password>(context);
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
                'Crie uma senha',
                style: TextStyle(
                  color: Color(0xFF111540),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Criei uma senha abaixo para continuar',
                style: TextStyle(color: AppColors.greyColor, fontSize: 13),
              ),
              SizedBox(height: 15),

              InputText(
                prefixIcon: Icons.key,
                hintText: 'Crie uma senha',
                keyboardType: .text,
                onChanged: (password) => userModelProvider.password = password,
                errorText: password.msgError,
              ),

              SizedBox(height: 6),

              Row(
                children: [
                  Checkbox(
                    splashRadius: 10,
                    activeColor: AppColors.mainColor,
                    value: userModelProvider.isCheck,
                    onChanged: userModelProvider.onChange,
                  ),
                  Expanded(
                    child: Text(
                      'Aceito os termos de uso e a política de privacidade',
                      overflow: .fade,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              EventButton(
                key: ValueKey('password'),
                userModelProvider: userModelProvider,
                onTap: () async {
                  password.validate(userModelProvider.password);

                  if (password.getValue != null) {
                    await NavigatorsApp.push(context, AddInfoSitioPage());
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
