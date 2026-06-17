import 'package:flutter/material.dart';

enum AppLocale {
  pt('pt', 'pt-BR', 'PT', '🇧🇷', 'Português'),
  en('en', 'en-US', 'EN', '🇺🇸', 'English'),
  es('es', 'es-ES', 'ES', '🇪🇸', 'Español');

  final String code;
  final String bcp47;
  final String shortLabel;
  final String flag;
  final String nativeName;
  const AppLocale(
      this.code, this.bcp47, this.shortLabel, this.flag, this.nativeName);
}

class LocaleProvider extends ChangeNotifier {
  AppLocale _locale = AppLocale.pt;
  AppLocale get locale => _locale;

  bool get isPt => _locale == AppLocale.pt;
  bool get isEn => _locale == AppLocale.en;
  bool get isEs => _locale == AppLocale.es;

  void cycle() {
    const order = AppLocale.values;
    _locale = order[(_locale.index + 1) % order.length];
    notifyListeners();
  }

  void set(AppLocale l) {
    if (_locale == l) return;
    _locale = l;
    notifyListeners();
  }
}
