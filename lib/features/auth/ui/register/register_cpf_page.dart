import 'package:agroshare/features/auth/form/fields/cpf_field.dart';
import 'package:agroshare/features/auth/form/auth_form.dart';
import 'package:agroshare/core/navigation/app_navigator.dart';
import 'package:agroshare/core/theme/app_colors.dart';
import 'package:agroshare/core/widgets/app_text_field.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_background.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_card.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_button.dart';
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
                'Seu CPF',
                style: TextStyle(
                  color: Color(0xFF111540),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Preencha abaixo com o seu CPF',
                style: TextStyle(color: AppColors.greyColor, fontSize: 13),
              ),
              SizedBox(height: 15),

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

              SizedBox(height: 12),

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
