import 'package:agroshare/features/auth/form/fields/password_field.dart';
import 'package:agroshare/features/auth/form/auth_form.dart';
import 'package:agroshare/core/navigation/app_navigator.dart';
import 'package:agroshare/core/theme/app_colors.dart';
import 'package:agroshare/core/widgets/app_text_field.dart';
import 'package:agroshare/features/auth/ui/register/register_farm_page.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_background.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_card.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class RegisterPasswordPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthForm userModelProvider = Provider.of<AuthForm>(context);
    final PasswordField password = Provider.of<PasswordField>(context);
    return Scaffold(
      floatingActionButtonLocation: .startTop,
      floatingActionButton: Padding(
        padding: .only(left: 5, top: 20),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(BoxIcons.bx_arrow_back, color: AppColors.whiteColor),
        ),
      ),
      body: AuthBackground(
        children: [
          AuthCard(
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

              AppTextField(
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

              AuthButton(
                key: ValueKey('password'),
                userModelProvider: userModelProvider,
                onTap: () async {
                  password.validate(userModelProvider.password);

                  if (password.getValue != null) {
                    await AppNavigator.push(context, RegisterFarmPage());
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
