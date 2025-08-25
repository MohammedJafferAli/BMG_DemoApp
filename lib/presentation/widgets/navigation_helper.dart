import 'package:flutter/material.dart';

class NavigationHelper {
  static bool canGoBack(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  static void goBack(BuildContext context) {
    if (canGoBack(context)) {
      Navigator.of(context).pop();
    }
  }

  static void goBackToRoot(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  static void goBackWithResult<T>(BuildContext context, T result) {
    Navigator.of(context).pop(result);
  }
}