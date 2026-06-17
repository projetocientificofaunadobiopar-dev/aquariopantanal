import 'package:flutter/material.dart';

/// 4 níveis discretos de escala de texto: 0.85 / 1.0 / 1.15 / 1.30.
class TextScaleProvider extends ChangeNotifier {
  static const List<double> escalas = [0.85, 1.0, 1.15, 1.30];

  int _idx = 1; // 1.0
  int get idx => _idx;
  double get scale => escalas[_idx];

  bool get podeDiminuir => _idx > 0;
  bool get podeAumentar => _idx < escalas.length - 1;

  void diminuir() {
    if (!podeDiminuir) return;
    _idx -= 1;
    notifyListeners();
  }

  void aumentar() {
    if (!podeAumentar) return;
    _idx += 1;
    notifyListeners();
  }

  void resetar() {
    if (_idx == 1) return;
    _idx = 1;
    notifyListeners();
  }
}
