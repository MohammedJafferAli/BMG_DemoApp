import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';

class HomeMainPage extends StatelessWidget {
  const HomeMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMG'),
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
                Icons.home,
                size: ResponsiveUtils.iconSize(context, mobile: 64),
                color: AppColors.primary,
              ),
              SizedBox(height: ResponsiveUtils.spacing(context)),
              Text(
                'Welcome Home',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(context, mobile: 20),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8)),
              Text(
                'Your gateway to amazing stays',
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