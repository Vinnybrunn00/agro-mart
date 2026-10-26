import 'package:agroshare/core/theme/app_colors.dart';
import 'package:flutter/widgets.dart';

class AuthBackground extends StatelessWidget {
  final List<Widget> children;
  const new({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      alignment: .center,
      padding: .only(left: 15, right: 15),
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 11, 41, 25),
            Color(0xFF2F6B4A),
            AppColors.mainColor,
          ],
          stops: [0.0, 1, 1.0],
        ),
      ),
      child: Column(mainAxisAlignment: .center, children: children),
    );
  }
}
