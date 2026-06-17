import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

@JS('__pwaCanInstall')
external JSFunction? _canInstallFn;

@JS('__pwaInstall')
external JSFunction? _installFn;

@JS('__pwaIsStandalone')
external JSFunction? _isStandaloneFn;

class PwaInstallService {
  PwaInstallService._();
  static final PwaInstallService instance = PwaInstallService._();

  static const _dismissKey = 'bp_pwa_dismissed_at';

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
    final dias = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(ts))
        .inDays;
    // Mostra de novo depois de 7 dias
    return dias < 7;
  }

  void dispensar() {
    if (!kIsWeb) return;
    web.window.localStorage.setItem(
      _dismissKey,
      DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }
}
