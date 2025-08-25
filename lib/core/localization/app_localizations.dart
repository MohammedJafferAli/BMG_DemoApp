import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('es', 'ES'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'BMG - Book My Guest',
      'search_hotels': 'Search Hotels',
      'find_your_stay': 'Find Your Stay',
      'welcome_home': 'Welcome Home',
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'book_now': 'Book Now',
      'confirm_booking': 'Confirm Booking',
      'payment': 'Payment',
      'total_amount': 'Total Amount',
      'booking_confirmed': 'Booking Confirmed!',
      'no_hotels_found': 'No hotels found',
      'search_placeholder': 'Search hotels by name...',
    },
    'hi': {
      'app_title': 'BMG - बुक माई गेस्ट',
      'search_hotels': 'होटल खोजें',
      'find_your_stay': 'अपना ठहरना खोजें',
      'welcome_home': 'घर में आपका स्वागत है',
      'sign_in': 'साइन इन करें',
      'sign_up': 'साइन अप करें',
      'book_now': 'अभी बुक करें',
      'confirm_booking': 'बुकिंग की पुष्टि करें',
      'payment': 'भुगतान',
      'total_amount': 'कुल राशि',
      'booking_confirmed': 'बुकिंग की पुष्टि हो गई!',
      'no_hotels_found': 'कोई होटल नहीं मिला',
      'search_placeholder': 'नाम से होटल खोजें...',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  String get appTitle => translate('app_title');
  String get searchHotels => translate('search_hotels');
  String get findYourStay => translate('find_your_stay');
  String get welcomeHome => translate('welcome_home');
  String get signIn => translate('sign_in');
  String get signUp => translate('sign_up');
  String get bookNow => translate('book_now');
  String get confirmBooking => translate('confirm_booking');
  String get payment => translate('payment');
  String get totalAmount => translate('total_amount');
  String get bookingConfirmed => translate('booking_confirmed');
  String get noHotelsFound => translate('no_hotels_found');
  String get searchPlaceholder => translate('search_placeholder');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}