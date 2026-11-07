/*
 * lib/features/profile/ui/logout_confirm_dialog.dart
 *
 * Caixa de diálogo que pede confirmação antes de sair da conta.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 07/11/2026
 */

import 'package:agroshare/core/theme/app_colors.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:material_ui/material_ui.dart';

class LogoutConfirmDialog extends StatelessWidget {
  const LogoutConfirmDialog({super.key});

  /// Retorna `true` se o usuário confirmar a saída,
  /// `false` se cancelar e `null` se fechar tocando fora.
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierColor: AppColors.blackColorAlpha120,
      builder: (_) => const LogoutConfirmDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundColorCard,
      insetPadding: .symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: .only(left: 22, right: 22, top: 26, bottom: 20),
        child: Column(
          mainAxisSize: .min,
          spacing: 18,
          children: [
            // ÍCONE
            Container(
              height: 58,
              width: 58,
              alignment: .center,
              decoration: BoxDecoration(
                shape: .circle,
                color: Colors.redAccent.withAlpha(30),
              ),
              child: Icon(
                Iconsax.logout_outline,
                size: 26,
                color: Colors.redAccent,
              ),
            ),

            // TÍTULO E MENSAGEM
            Column(
              spacing: 6,
              children: [
                Text(
                  'Sair da conta?',
                  textAlign: .center,
                  style: TextStyle(
                    fontSize: 17,
                    color: AppColors.textColor,
                    fontWeight: .w600,
                  ),
                ),
                Text(
                  'Você precisará entrar novamente para acessar seus anúncios e pedidos.',
                  textAlign: .center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.blackColorAlpha120,
                  ),
                ),
              ],
            ),

            // BOTÕES
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: _DialogButton(
                    title: 'Cancelar',
                    textColor: AppColors.textColor,
                    backgroundColor: AppColors.backgroundColorWhite,
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                ),
                Expanded(
                  child: _DialogButton(
                    title: 'Sair',
                    textColor: AppColors.whiteColor,
                    backgroundColor: Colors.redAccent,
                    onTap: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String _title;
  final Color _textColor;
  final Color _backgroundColor;
  final void Function() _onTap;

  const _DialogButton({
    required this._title,
    required this._textColor,
    required this._backgroundColor,
    required this._onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _onTap,
        child: Padding(
          padding: .symmetric(vertical: 13),
          child: Text(
            _title,
            textAlign: .center,
            style: TextStyle(
              fontSize: 14,
              color: _textColor,
              fontWeight: .w600,
            ),
          ),
        ),
      ),
    );
  }
}
