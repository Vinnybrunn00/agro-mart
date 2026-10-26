import 'package:agroshare/features/auth/form/fields/email_field.dart';
import 'package:agroshare/features/auth/form/auth_form.dart';
import 'package:agroshare/core/navigation/app_navigator.dart';
import 'package:agroshare/core/theme/app_colors.dart';
import 'package:agroshare/core/widgets/app_text_field.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_background.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_card.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_button.dart';
import 'package:agroshare/features/auth/ui/register/register_password_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class RegisterEmailPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthForm userModelProvider = Provider.of<AuthForm>(context);
    final EmailField email = Provider.of<EmailField>(context);
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
              AppTextField(
                prefixIcon: EvaIcons.email_outline,
                hintText: 'Email',
                keyboardType: .emailAddress,
                onChanged: (email) => userModelProvider.email = email,
                errorText: email.msgError,
              ),

              SizedBox(height: 12),

              AuthButton(
                userModelProvider: userModelProvider,
                onTap: () async {
                  email.validate(userModelProvider.email);

                  if (email.getValue != null) {

                    await AppNavigator.push(context, RegisterPasswordPage());
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
