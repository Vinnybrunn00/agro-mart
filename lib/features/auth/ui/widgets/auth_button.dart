import 'package:agroshare/features/auth/form/auth_form.dart';
import 'package:agroshare/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// botão de entrar e criar conta
class AuthButton extends StatelessWidget {
  final String? title;
  final AuthForm _userModelProvider;
  final void Function()? _onTap;

  const AuthButton({
    super.key,
    required this._userModelProvider,
    required this._onTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      key: key,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: key == null ? _onTap : (_checkTermos ? _onTap : null),
        child: Ink(
          height: 50,
          width: size.width,
          decoration: BoxDecoration(
            color: key == null ? AppColors.mainColor : _checkTermosForColor(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: _userModelProvider.isLoading
                ? CircularProgressIndicator(
                    color: AppColors.whiteColor,
                    strokeWidth: 3,
                  )
                : Text(
                    title ?? 'Continuar',
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
          ),
        ),
      ),
    );
  }

  bool get _checkTermos => _userModelProvider.isCheck!;

  Color? _checkTermosForColor() {
    return _userModelProvider.isCheck!
        ? AppColors.mainColor
        : AppColors.mainColor.withAlpha(150);
  }
}
