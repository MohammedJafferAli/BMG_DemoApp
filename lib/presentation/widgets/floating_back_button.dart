import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FloatingBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const FloatingBackButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!Navigator.of(context).canPop()) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 0,
      left: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}