import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

@JS('__pwaCanInstall')
external JSFunction? _canInstallFn;

@JS('__pwaInstall')
external JSFunction? _installFn;

@JS('__pwaIsStandalone')
external JSFunction? _isStandaloneFn;

enum PwaPlatform { android, ios, desktop, other }

class PwaInstallService {
  PwaInstallService._();
  static final PwaInstallService instance = PwaInstallService._();

  static const _dismissKey = 'bp_pwa_dismissed_at';
  // 24h em milissegundos
  static const _dismissDuration = 24 * 60 * 60 * 1000;

  /// Detecta a plataforma pra mostrar instruções específicas.
  PwaPlatform get platform {
    if (!kIsWeb) return PwaPlatform.other;
    final ua = web.window.navigator.userAgent.toLowerCase();
    if (ua.contains('iphone') ||
        ua.contains('ipad') ||
        ua.contains('ipod')) {
      return PwaPlatform.ios;
    }
    if (ua.contains('android')) return PwaPlatform.android;
    if (ua.contains('windows') ||
        ua.contains('macintosh') ||
        ua.contains('linux')) {
      return PwaPlatform.desktop;
    }
    return PwaPlatform.other;
  }

  bool get canInstall {
    if (!kIsWeb) return false;
    final fn = _canInstallFn;
    if (fn == null) return false;
    final r = fn.callAsFunction();
    return (r as JSBoolean?)?.toDart ?? false;
  }

  bool get isStandalone {
    if (!kIsWeb) return false;
    final fn = _isStandaloneFn;
    if (fn == null) return false;
    final r = fn.callAsFunction();
    return (r as JSBoolean?)?.toDart ?? false;
  }

  Future<String> install() async {
    if (!kIsWeb) return 'unavailable';
    final fn = _installFn;
    if (fn == null) return 'unavailable';
    final result = await (fn.callAsFunction() as JSPromise).toDart;
    return (result as JSString?)?.toDart ?? 'dismissed';
  }

  bool foiDispensado() {
    if (!kIsWeb) return false;
    final stored = web.window.localStorage.getItem(_dismissKey);
    if (stored == null) return false;
    final ts = int.tryParse(stored);
    if (ts == null) return false;
    final agora = DateTime.now().millisecondsSinceEpoch;
    return (agora - ts) < _dismissDuration;
  }

  void dispensar() {
    if (!kIsWeb) return;
    web.window.localStorage.setItem(
      _dismissKey,
      DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  /// Apaga o cooldown de dispensa (forçar mostrar de novo).
  void resetar() {
    if (!kIsWeb) return;
    web.window.localStorage.removeItem(_dismissKey);
  }
}
