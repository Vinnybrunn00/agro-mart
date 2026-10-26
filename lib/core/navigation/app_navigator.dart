import 'package:flutter/material.dart';

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
