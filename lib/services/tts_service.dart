import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import '../providers/locale_provider.dart';

class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  Future<void> falar(String texto, {required AppLocale loc}) async {
    if (!kIsWeb) return;
    if (texto.trim().isEmpty) return;
    final synth = web.window.speechSynthesis;
    synth.cancel();
    final utt = web.SpeechSynthesisUtterance(texto)
      ..lang = loc.bcp47
      ..rate = 0.95
      ..pitch = 1.0
      ..volume = 1.0;
    synth.speak(utt);
  }

  Future<void> parar() async {
    if (!kIsWeb) return;
    web.window.speechSynthesis.cancel();
  }
}
