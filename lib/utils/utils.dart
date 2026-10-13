import 'dart:async';

import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:flutter/material.dart';

enum MessageType { success, error, warning, info }

class Utils {
  static OverlayEntry? _currentMessage;

  static void showMessage(
    BuildContext context, {
    required String message,
    MessageType type = MessageType.info,
    String? title,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    bool showCloseIcon = false,
    bool floating = true,
    double borderRadius = 12,
    EdgeInsetsGeometry? margin,
  }) {
    final OverlayState overlay = Overlay.of(context, rootOverlay: true);

    hideMessage();

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _FloatingMessage(
        message: message,
        title: title,
        icon: icon ?? _iconOf(type),
        backgroundColor: backgroundColor ?? _colorOf(type),
        textColor: textColor ?? AppColors.whiteColor,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
        showCloseIcon: showCloseIcon,
        borderRadius: floating ? borderRadius : 0,
        margin: floating ? margin ?? const EdgeInsets.all(16) : EdgeInsets.zero,
        onDismissed: () {
          if (_currentMessage == entry) hideMessage();
        },
      ),
    );

    _currentMessage = entry;
    overlay.insert(entry);
  }

  static void hideMessage() {
    _currentMessage?.remove();
    _currentMessage = null;
  }

  static Color _colorOf(MessageType type) => switch (type) {
    MessageType.success => AppColors.mainColor,
    MessageType.error => const Color(0xffC0392B),
    MessageType.warning => const Color(0xffB9770E),
    MessageType.info => AppColors.textColor,
  };

  static IconData _iconOf(MessageType type) => switch (type) {
    MessageType.success => Icons.check_circle_outline,
    MessageType.error => Icons.error_outline,
    MessageType.warning => Icons.warning_amber_rounded,
    MessageType.info => Icons.info_outline,
  };
}

class _FloatingMessage extends StatefulWidget {
  const _FloatingMessage({
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.duration,
    required this.showCloseIcon,
    required this.borderRadius,
    required this.margin,
    required this.onDismissed,
    this.title,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? title;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showCloseIcon;
  final double borderRadius;
  final EdgeInsetsGeometry margin;
  final VoidCallback onDismissed;

  @override
  State<_FloatingMessage> createState() => _FloatingMessageState();
}

class _FloatingMessageState extends State<_FloatingMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
    _timer = Timer(widget.duration, _dismiss);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    _timer?.cancel();
    await _controller.reverse();
    if (mounted) widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: MediaQuery.viewInsetsOf(context).bottom,
      child: SafeArea(
        child: Padding(
          padding: widget.margin,
          child: FadeTransition(
            opacity: _animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(_animation),
              child: Material(
                elevation: 6,
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(widget.icon, color: widget.textColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.title != null)
                              Text(
                                widget.title!,
                                style: TextStyle(
                                  color: widget.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            Text(
                              widget.message,
                              style: TextStyle(color: widget.textColor),
                            ),
                          ],
                        ),
                      ),
                      if (widget.actionLabel != null)
                        TextButton(
                          onPressed: () {
                            widget.onAction?.call();
                            _dismiss();
                          },
                          child: Text(
                            widget.actionLabel!,
                            style: TextStyle(
                              color: widget.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (widget.showCloseIcon)
                        IconButton(
                          onPressed: _dismiss,
                          icon: Icon(Icons.close, color: widget.textColor),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
