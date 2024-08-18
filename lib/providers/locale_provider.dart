import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_es.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_fr.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ja.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ko.dart';

class LocaleProvider extends ChangeNotifier {
  Locale locale = const Locale('en');
  late SharedPreferences _prefs;

  LocaleProvider() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    locale = Locale(_prefs.getString('langCode') ?? 'en');

    notifyListeners();
  }

  void switchLocale() {
    const locales = AppLocalizations.supportedLocales;
    int currentIndex = locales.indexOf(locale);
    int nextIndex = (currentIndex + 1) % locales.length;

    locale = locales[nextIndex];
    _prefs.setString('langCode', locale.languageCode);
    notifyListeners();
  }

  AppLocalizations currentLocalization() {
    switch (locale.languageCode) {
      case 'en':
        return AppLocalizationsEn();
      case 'es':
        return AppLocalizationsEs();
      case 'fr':
        return AppLocalizationsFr();
      case 'ja':
        return AppLocalizationsJa();
      case 'ko':
        return AppLocalizationsKo();
      default:
        return AppLocalizationsEn();
    }
  }
}
