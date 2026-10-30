import 'package:agroshare/features/auth/form/fields/cpf_field.dart';
import 'package:agroshare/features/auth/form/auth_form.dart';
import 'package:agroshare/core/navigation/app_navigator.dart';
import 'package:agroshare/core/widgets/app_text_field.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_back_button.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_background.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_card.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_button.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_header.dart';
import 'package:agroshare/features/auth/ui/register/register_email_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class RegisterCpfPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthForm userModelProvider = Provider.of<AuthForm>(context);
    final CpfField cpf = Provider.of<CpfField>(context);
    return Scaffold(
      floatingActionButtonLocation: .startTop,
      floatingActionButton: AuthBackButton(),
      body: AuthBackground(
        children: [
          AuthCard(
            children: [
              AuthHeader(
                step: 2,
                icon: BoxIcons.bx_id_card,
                title: 'Seu CPF',
                subtitle: 'Usamos o CPF para garantir a segurança entre os produtores.',
              ),

              AppTextField(
                prefixIcon: BoxIcons.bx_credit_card,
                hintText: 'CPF',
                keyboardType: .number,
                onChanged: (cpf) => userModelProvider.cpf = cpf,
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '###.###.###-##',
                    filter: {"#": RegExp(r'[0-9]')},
                  ),
                ],
                errorText: cpf.msgError,
              ),

              SizedBox(height: 20),

              AuthButton(
                userModelProvider: userModelProvider,
                onTap: () async {
                  cpf.validate(userModelProvider.cpf);
                  if (cpf.getValue != null) {
                    await AppNavigator.push(context, RegisterEmailPage());
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
