import 'package:agroshare/core/theme/app_colors.dart';
import 'package:flutter/widgets.dart';

class AuthBackground extends StatelessWidget {
  final List<Widget> children;
  const new({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B2919), Color(0xFF1D4A32), AppColors.mainColor],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // CIRCULOS DECORATIVOS
          Positioned(
            top: -size.width * 0.35,
            right: -size.width * 0.3,
            child: _Circle(diameter: size.width * 0.9, alpha: 14),
          ),
          Positioned(
            bottom: -size.width * 0.45,
            left: -size.width * 0.35,
            child: _Circle(diameter: size.width * 1.1, alpha: 10),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: .symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: Column(mainAxisAlignment: .center, children: children),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double diameter;
  final int alpha;

  const _Circle({required this.diameter, required this.alpha});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        shape: .circle,
        color: AppColors.whiteColor.withAlpha(alpha),
      ),
    );
  }
}
