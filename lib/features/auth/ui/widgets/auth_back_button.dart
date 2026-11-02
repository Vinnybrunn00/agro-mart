/*
 * lib/features/auth/ui/widgets/auth_back_button.dart
 *
 * Botão de voltar das telas de cadastro.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 30/10/2026
 */

import 'package:agroshare/core/theme/app_colors.dart';
import 'package:material_ui/material_ui.dart';
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
