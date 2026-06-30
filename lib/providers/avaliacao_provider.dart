import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Marca se o visitante já avaliou o app (uma vez por dispositivo).
class AvaliacaoProvider extends ChangeNotifier {
  static const _key = 'avaliacao_enviada_v1';
  static const _keyDispensada = 'avaliacao_dispensada_v1';

  bool? _enviada;
  bool _dispensada = false;

  bool get jaEnviou => _enviada == true;
  bool get dispensada => _dispensada;
  bool get devePerguntar => _enviada == false && !_dispensada;

  Future<void> carregar() async {
    final p = await SharedPreferences.getInstance();
    _enviada = p.getBool(_key) ?? false;
    _dispensada = p.getBool(_keyDispensada) ?? false;
    notifyListeners();
  }

  Future<void> marcarEnviada() async {
    _enviada = true;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool(_key, true);
  }

  Future<void> dispensar() async {
    _dispensada = true;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool(_keyDispensada, true);
  }
}
