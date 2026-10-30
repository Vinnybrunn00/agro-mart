import 'package:agroshare/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';

// botão de voltar das telas de cadastro
class AuthBackButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .only(left: 8, top: 12),
      child: Material(
        color: AppColors.whiteColor.withAlpha(30),
        shape: CircleBorder(
          side: BorderSide(color: AppColors.whiteColor.withAlpha(50)),
        ),
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: () => Navigator.pop(context),
          child: SizedBox(
            height: 42,
            width: 42,
            child: Icon(
              BoxIcons.bx_arrow_back,
              color: AppColors.whiteColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
