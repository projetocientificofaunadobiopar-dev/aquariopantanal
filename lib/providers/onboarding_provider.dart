import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Marca se o onboarding inicial já foi exibido.
class OnboardingProvider extends ChangeNotifier {
  static const _key = 'onboarding_done_v1';

  bool? _done; // null = ainda não carregou
  bool get carregado => _done != null;
  bool get done => _done == true;

  Future<void> carregar() async {
    if (_done != null) return;
    final p = await SharedPreferences.getInstance();
    _done = p.getBool(_key) ?? false;
    notifyListeners();
  }

  Future<void> concluir() async {
    _done = true;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool(_key, true);
  }

  Future<void> resetar() async {
    _done = false;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.remove(_key);
  }
}
