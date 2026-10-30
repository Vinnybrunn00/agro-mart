import 'package:agroshare/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// cabeçalho padrão das telas de cadastro (etapa, icone, titulo e subtitulo)
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final int? step;
  final int totalSteps;

  const new({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.step,
    this.totalSteps = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        if (step != null) ...[
          _StepIndicator(step: step!, totalSteps: totalSteps),
          SizedBox(height: 22),
        ],

        // ICONE
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppColors.mainColor.withAlpha(25),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.mainColor, size: 24),
        ),
        SizedBox(height: 16),

        // TITULO
        Text(
          title,
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 22,
            fontWeight: .w700,
            height: 1.2,
          ),
        ),
        SizedBox(height: 6),

        // SUBTITULO
        Text(
          subtitle,
          style: TextStyle(
            color: AppColors.greyColor,
            fontSize: 13.5,
            height: 1.4,
          ),
        ),
        SizedBox(height: 22),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int step;
  final int totalSteps;

  const _StepIndicator({required this.step, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 8,
      children: [
        Text(
          'ETAPA $step DE $totalSteps',
          style: TextStyle(
            color: AppColors.mainColor,
            fontSize: 11,
            fontWeight: .w700,
            letterSpacing: 1.1,
          ),
        ),
        Row(
          spacing: 5,
          children: [
            for (int i = 1; i <= totalSteps; i++)
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 4,
                  decoration: BoxDecoration(
                    color: i <= step
                        ? AppColors.mainColor
                        : AppColors.mainColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
