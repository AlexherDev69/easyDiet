import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Title text with emerald gradient fill effect.
class GradientTitle extends StatelessWidget {
  const GradientTitle(
    this.text, {
    this.style,
    this.textAlign,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ??
        Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            );

    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppColors.emeraldPrimary, AppColors.emeraldDark],
      ).createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        style: effectiveStyle,
        textAlign: textAlign,
      ),
    );
  }
}
