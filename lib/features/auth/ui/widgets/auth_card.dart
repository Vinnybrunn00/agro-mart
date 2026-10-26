import 'package:agroshare/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthCard extends StatelessWidget {
  final double spacing;
  final List<Widget> _children;

  const new({super.key, required this._children, this.spacing = 0.0});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: .center,
      duration: Duration(milliseconds: 450),
      padding: .only(top: 45, left: 15, right: 15, bottom: 45),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: spacing,
        crossAxisAlignment: .start,
        mainAxisAlignment: .center,
        children: _children,
      ),
    );
  }
}
