import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../i18n/strings.dart';
import '../providers/locale_provider.dart';
import '../services/pwa_install_service.dart';

class PwaInstallBanner extends StatefulWidget {
  const PwaInstallBanner({super.key});

  @override
  State<PwaInstallBanner> createState() => _PwaInstallBannerState();
}

class _PwaInstallBannerState extends State<PwaInstallBanner> {
  bool _checked = false;
  bool _show = false;
  PwaPlatform _platform = PwaPlatform.other;
  bool _canPromptNative = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Pequeno delay pra deixar o beforeinstallprompt disparar.
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      final pwa = PwaInstallService.instance;
      final platform = pwa.platform;
      final canNative = pwa.canInstall;
      final dismissed = pwa.foiDispensado();
      final installed = pwa.isStandalone;

      // Regra: aparece se NÃO está instalado E NÃO foi dispensado nas últimas 24h.
      // No iOS (que nunca tem `canNative` true), mostra instruções manuais.
      final visivel = !installed && !dismissed;

      setState(() {
        _checked = true;
        _show = visivel;
        _platform = platform;
        _canPromptNative = canNative;
      });
    });
  }

  void _dispensar() {
    PwaInstallService.instance.dispensar();
    setState(() => _show = false);
  }

  Future<void> _instalar(Strings s) async {
    if (_canPromptNative) {
      final r = await PwaInstallService.instance.install();
      if (!mounted) return;
      if (r == 'accepted' || r == 'dismissed') {
        setState(() => _show = false);
      }
    } else if (_platform == PwaPlatform.ios) {
      // iOS: abre modal com instruções manuais.
      _mostrarIosInstr(s);
    } else {
      // Browser que ainda não disparou o prompt — mostra instruções genéricas.
      _mostrarFallback(s);
    }
  }

  Future<void> _mostrarIosInstr(Strings s) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.ios_share_rounded),
            const SizedBox(width: 10),
            Expanded(child: Text(s.instalarIosTitulo)),
          ],
        ),
        content: Text(s.instalarIosInstr, style: const TextStyle(height: 1.5)),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(s.entendi),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarFallback(Strings s) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(s.instalarApp),
        content: Text(
          s.loc == AppLocale.en
              ? 'In your browser menu, look for "Install app" or "Add to Home Screen". The exact option depends on the browser.'
              : s.loc == AppLocale.es
                  ? 'En el menú del navegador busca "Instalar aplicación" o "Agregar a pantalla de inicio". La opción exacta depende del navegador.'
                  : 'No menu do navegador, procure "Instalar aplicativo" ou "Adicionar à tela inicial". A opção exata depende do navegador.',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(s.entendi),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked || !_show) return const SizedBox.shrink();
    final s = Strings(context.watch<LocaleProvider>().locale);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 22),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(18),
          border:
              Border.all(color: Colors.white.withOpacity(0.25), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.install_mobile_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    s.instalarApp,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s.instalarAppDesc,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12.5,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: s.agoraNao,
              onPressed: _dispensar,
              icon: Icon(Icons.close_rounded,
                  color: Colors.white.withOpacity(0.85)),
            ),
            const SizedBox(width: 2),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () => _instalar(s),
              child: Text(
                s.instalar,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 13),
              ),
            ),
            const SizedBox(width: 2),
          ],
        ),
      ),
    );
  }
}
