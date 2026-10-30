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
    final Color color = key == null
        ? AppColors.mainColor
        : _checkTermosForColor()!;
    return Material(
      key: key,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: key == null ? _onTap : (_checkTermos ? _onTap : null),
        child: Ink(
          height: 52,
          width: size.width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              if (color.a == 1)
                BoxShadow(
                  color: AppColors.mainColor.withAlpha(90),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
            ],
          ),
          child: Center(
            child: _userModelProvider.isLoading
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: AppColors.whiteColor,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisSize: .min,
                    spacing: 8,
                    children: [
                      Text(
                        title ?? 'Continuar',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 15,
                          fontWeight: .w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.whiteColor,
                        size: 18,
                      ),
                    ],
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
