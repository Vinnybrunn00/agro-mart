import 'package:agroshare/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthCard extends StatelessWidget {
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> _children;

  const new({
    super.key,
    required this._children,
    this.spacing = 0.0,
    this.crossAxisAlignment = .start,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: .center,
      duration: Duration(milliseconds: 450),
      width: double.infinity,
      padding: .symmetric(horizontal: 22, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 30,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        spacing: spacing,
        mainAxisSize: .min,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: .center,
        children: _children,
      ),
    );
  }
}
