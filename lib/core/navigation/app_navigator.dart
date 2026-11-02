/*
 * lib/core/navigation/app_navigator.dart
 *
 * Atalhos de navegação entre telas do app.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 08/09/2026
 */

import 'package:material_ui/material_ui.dart';

abstract class AppNavigator {
  static Future<void> pushAndRemoveUntil(
    BuildContext context,
    Widget page,
  ) async {
    await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  static Future<void> push(BuildContext context, Widget page) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}
