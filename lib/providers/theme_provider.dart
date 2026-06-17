import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Sempre inicia em tema claro pra evitar dependência do brilho do sistema.
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void set(ThemeMode m) {
    if (_mode == m) return;
    _mode = m;
    notifyListeners();
  }
}
