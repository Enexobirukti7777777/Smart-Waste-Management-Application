import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Smart Waste Collector',
      'services': 'Services',
      'pickup_request': 'Extra Pickup Request',
      'ai_chat': 'AI Chat',
      'track_collector': 'Track Collector',
      'logout': 'Logout',
      'profile': 'Profile',
      'payment': 'Payment & Wallet',
      'language': 'Language',
      'rate_app': 'Rate This App',
    },
    'am': {
      'app_title': 'ዘመናዊ ቆሻሻ ሰብሳቢ',
      'services': 'አገልግሎቶች',
      'pickup_request': 'ተጨማሪ ቆሻሻ መሰብሰቢያ',
      'ai_chat': 'ኤአይ ቻት',
      'track_collector': 'ሰብሳቢውን ተከታተል',
      'logout': 'ውጣ',
      'profile': 'ፕሮፋይል',
      'payment': 'ክፍያ ',
      'language': 'ቋንቋ',
      'rate_app': 'መተግበሪያውን ደረጃ ይስጡ',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]!['app_title']!;
  String get services => _localizedValues[locale.languageCode]!['services']!;
  String get pickupRequest => _localizedValues[locale.languageCode]!['pickup_request']!;
  String get aiChat => _localizedValues[locale.languageCode]!['ai_chat']!;
  String get trackCollector => _localizedValues[locale.languageCode]!['track_collector']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get payment => _localizedValues[locale.languageCode]!['payment']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get rateApp => _localizedValues[locale.languageCode]!['rate_app']!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'am'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}