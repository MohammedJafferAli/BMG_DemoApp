import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: ResponsiveUtils.contentMaxWidth(context)),
          padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.help_outline,
                size: ResponsiveUtils.iconSize(context, mobile: 64),
                color: AppColors.primary,
              ),
              SizedBox(height: ResponsiveUtils.spacing(context)),
              Text(
                'Help & Support',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(context, mobile: 20),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8)),
              Text(
                'Get assistance with your bookings and account',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(context, mobile: 14),
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}