import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;

  const BackButtonWidget({
    super.key,
    this.onPressed,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: Icon(
        Icons.arrow_back_ios,
        color: color ?? AppColors.textPrimary,
        size: size ?? 24,
      ),
    );
  }
}