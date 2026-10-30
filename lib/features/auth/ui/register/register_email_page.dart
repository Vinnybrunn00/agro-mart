import 'package:agroshare/features/auth/form/fields/email_field.dart';
import 'package:agroshare/features/auth/form/auth_form.dart';
import 'package:agroshare/core/navigation/app_navigator.dart';
import 'package:agroshare/core/widgets/app_text_field.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_back_button.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_background.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_card.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_button.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_header.dart';
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
      floatingActionButton: AuthBackButton(),
      body: AuthBackground(
        children: [
          AuthCard(
            children: [
              AuthHeader(
                step: 3,
                icon: EvaIcons.email_outline,
                title: 'Seu email',
                subtitle: 'Você usará este email para entrar no AgroShare.',
              ),
              AppTextField(
                prefixIcon: EvaIcons.email_outline,
                hintText: 'Email',
                keyboardType: .emailAddress,
                onChanged: (email) => userModelProvider.email = email,
                errorText: email.msgError,
              ),

              SizedBox(height: 20),

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
