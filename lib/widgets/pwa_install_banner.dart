import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../i18n/strings.dart';
import '../providers/locale_provider.dart';
import '../services/pwa_install_service.dart';
import 'app_icons.dart';

class PwaInstallBanner extends StatefulWidget {
  const PwaInstallBanner({super.key});

  @override
  State<PwaInstallBanner> createState() => _PwaInstallBannerState();
}

class _PwaInstallBannerState extends State<PwaInstallBanner> {
  bool _checked = false;
  bool _show = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Espera um pouco para o beforeinstallprompt disparar
      await Future<void>.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      final pwa = PwaInstallService.instance;
      final visivel = pwa.canInstall &&
          !pwa.isStandalone &&
          !pwa.foiDispensado();
      setState(() {
        _checked = true;
        _show = visivel;
      });
    });
  }

  void _dispensar() {
    PwaInstallService.instance.dispensar();
    setState(() => _show = false);
  }

  Future<void> _instalar() async {
    final r = await PwaInstallService.instance.install();
    if (!mounted) return;
    if (r == 'accepted' || r == 'dismissed') {
      setState(() => _show = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked || !_show) return const SizedBox.shrink();
    final s = Strings(context.watch<LocaleProvider>().locale);
    final scheme = Theme.of(context).colorScheme;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 250),
      offset: _show ? Offset.zero : const Offset(0, 2),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.download_rounded,
                    color: Colors.white),
              ),
              const SizedBox(width: 12),
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
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        height: 1.3,
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
                icon: const Icon(Icons.close_rounded, color: Colors.white),
              ),
              const SizedBox(width: 4),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: scheme.primary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                ),
                onPressed: _instalar,
                child: Text(
                  s.instalar,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
