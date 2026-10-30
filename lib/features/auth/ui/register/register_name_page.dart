import 'package:agroshare/features/auth/form/fields/name_field.dart';
import 'package:agroshare/features/auth/form/auth_form.dart';
import 'package:agroshare/core/navigation/app_navigator.dart';
import 'package:agroshare/core/widgets/app_text_field.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_back_button.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_background.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_card.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_button.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_header.dart';
import 'package:agroshare/features/auth/ui/register/register_cpf_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class RegisterNamePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthForm userModelProvider = Provider.of<AuthForm>(context);
    final NameField name = Provider.of<NameField>(context);
    return Scaffold(
      floatingActionButtonLocation: .startTop,
      floatingActionButton: AuthBackButton(),
      body: AuthBackground(
        children: [
          AuthCard(
            children: [
              AuthHeader(
                step: 1,
                icon: BoxIcons.bx_user,
                title: 'Seu nome completo',
                subtitle:
                    'Como devemos te chamar? Informe seu nome e sobrenome.',
              ),
              AppTextField(
                prefixIcon: BoxIcons.bx_user,
                hintText: 'Nome Completo',
                keyboardType: .text,
                onChanged: (name) => userModelProvider.name = name,
                errorText: name.msgError,
              ),
              SizedBox(height: 20),

              AuthButton(
                userModelProvider: userModelProvider,
                onTap: () async {
                  name.validate(userModelProvider.name);
                  if (name.getValue != null) {
                    await AppNavigator.push(context, RegisterCpfPage());
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
