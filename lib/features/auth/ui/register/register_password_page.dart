import 'package:agroshare/features/auth/form/fields/password_field.dart';
import 'package:agroshare/features/auth/form/auth_form.dart';
import 'package:agroshare/core/navigation/app_navigator.dart';
import 'package:agroshare/core/theme/app_colors.dart';
import 'package:agroshare/core/widgets/app_text_field.dart';
import 'package:agroshare/features/auth/ui/register/register_farm_page.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_back_button.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_background.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_card.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_button.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPasswordPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthForm userModelProvider = Provider.of<AuthForm>(context);
    final PasswordField password = Provider.of<PasswordField>(context);
    return Scaffold(
      floatingActionButtonLocation: .startTop,
      floatingActionButton: AuthBackButton(),
      body: AuthBackground(
        children: [
          AuthCard(
            children: [
              AuthHeader(
                step: 4,
                icon: Icons.lock_outline_rounded,
                title: 'Crie uma senha',
                subtitle: 'Use letras maiúsculas, minúsculas, números e um caractere especial.',
              ),

              AppTextField(
                prefixIcon: Icons.key,
                hintText: 'Crie uma senha',
                keyboardType: .text,
                onChanged: (password) => userModelProvider.password = password,
                errorText: password.msgError,
              ),

              SizedBox(height: 14),

              Container(
                padding: .only(right: 12, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withAlpha(15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      splashRadius: 10,
                      activeColor: AppColors.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      value: userModelProvider.isCheck,
                      onChanged: userModelProvider.onChange,
                    ),
                    Expanded(
                      child: Text(
                        'Aceito os termos de uso e a política de privacidade',
                        overflow: .fade,
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

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
