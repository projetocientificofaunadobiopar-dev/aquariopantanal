import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

/// Detecta se o navegador está offline via window.navigator.onLine
/// e dispara updates quando o estado muda.
class ConexaoProvider extends ChangeNotifier {
  bool _online = true;
  bool get online => _online;
  bool get offline => !_online;

  ConexaoProvider() {
    if (kIsWeb) {
      _online = web.window.navigator.onLine;
      web.window.addEventListener(
        'online',
        (web.Event _) {
          _online = true;
          notifyListeners();
        }.toJS,
      );
      web.window.addEventListener(
        'offline',
        (web.Event _) {
          _online = false;
          notifyListeners();
        }.toJS,
      );
    }
  }
}
