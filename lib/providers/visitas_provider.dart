import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gerencia a lista de espécies que o visitante já viu (passaporte).
/// Persistido em localStorage via SharedPreferences.
class VisitasProvider extends ChangeNotifier {
  static const _key = 'especies_visitadas_v1';

  Set<String> _ids = {};
  bool _carregado = false;

  Set<String> get ids => _ids;
  int get total => _ids.length;
  bool get carregado => _carregado;

  bool foiVisitada(String id) => _ids.contains(id);

  Future<void> carregar() async {
    if (_carregado) return;
    final p = await SharedPreferences.getInstance();
    _ids = (p.getStringList(_key) ?? const []).toSet();
    _carregado = true;
    notifyListeners();
  }

  Future<void> marcarVisitada(String id) async {
    if (id.isEmpty || _ids.contains(id)) return;
    _ids = {..._ids, id};
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_key, _ids.toList());
  }

  Future<void> limpar() async {
    _ids = {};
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.remove(_key);
  }
}
