/*
 * lib/core/session/app_session.dart
 *
 * Sessão do app: permite recriar toda a árvore de widgets no logout.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 12/10/2026
 */

import 'package:flutter/widgets.dart';

/// Envolve a árvore do app e permite recriá-la do zero.
///
/// Ao chamar [AppSession.reset], tudo que está abaixo (providers, navegação e
/// estado das telas) é descartado e construído novamente, garantindo que nada
/// da conta anterior permaneça em memória após o logout.
class AppSession extends StatefulWidget {
  final WidgetBuilder builder;

  const AppSession({super.key, required this.builder});

  static void reset(BuildContext context) {
    context.findAncestorStateOfType<_AppSessionState>()?._reset();
  }

  @override
  State<AppSession> createState() => _AppSessionState();
}

class _AppSessionState extends State<AppSession> {
  Key _sessionKey = UniqueKey();

  void _reset() => setState(() => _sessionKey = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _sessionKey,
      child: Builder(builder: widget.builder),
    );
  }
}
