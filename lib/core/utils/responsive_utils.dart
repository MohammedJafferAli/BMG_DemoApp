import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Breakpoints following Material Design guidelines
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;
  
  // Device type detection
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }
  
  // Responsive values
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }
  
  // Standard spacing values
  static double spacing(BuildContext context, {
    double mobile = 16.0,
    double? tablet,
    double? desktop,
  }) {
    return responsive(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.25,
      desktop: desktop ?? mobile * 1.5,
    );
  }
  
  // Standard font sizes
  static double fontSize(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsive(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.1,
      desktop: desktop ?? mobile * 1.2,
    );
  }
  
  // Standard icon sizes
  static double iconSize(BuildContext context, {
    double mobile = 24.0,
    double? tablet,
    double? desktop,
  }) {
    return responsive(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.1,
      desktop: desktop ?? mobile * 1.2,
    );
  }
  
  // Standard border radius
  static double borderRadius(BuildContext context, {
    double mobile = 12.0,
    double? tablet,
    double? desktop,
  }) {
    return responsive(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.2,
      desktop: desktop ?? mobile * 1.4,
    );
  }
  
  // Content max width for better readability
  static double contentMaxWidth(BuildContext context) {
    return responsive(
      context,
      mobile: double.infinity,
      tablet: 600.0,
      desktop: 800.0,
    );
  }
  
  // Grid columns for responsive layouts
  static int gridColumns(BuildContext context) {
    return responsive(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
  }
  
  // Safe area padding
  static EdgeInsets safePadding(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final spacing = ResponsiveUtils.spacing(context);
    
    return EdgeInsets.only(
      left: spacing,
      right: spacing,
      top: padding.top + spacing,
      bottom: padding.bottom + spacing,
    );
  }
  
  // Minimum touch target size (44px for iOS, 48px for Android)
  static double minTouchTarget(BuildContext context) {
    return responsive(
      context,
      mobile: 44.0,
      tablet: 48.0,
      desktop: 48.0,
    );
  }
}

// Extension for easier access
extension ResponsiveContext on BuildContext {
  bool get isMobile => ResponsiveUtils.isMobile(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
  
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) =>
      ResponsiveUtils.responsive(
        this,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );
}