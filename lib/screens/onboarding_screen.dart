import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/lang_switch.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _t(AppLocale loc,
      {required String pt, required String en, required String es}) {
    switch (loc) {
      case AppLocale.pt:
        return pt;
      case AppLocale.en:
        return en;
      case AppLocale.es:
        return es;
    }
  }

  Future<void> _concluir() async {
    await context.read<OnboardingProvider>().concluir();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocaleProvider>().locale;
    final scheme = Theme.of(context).colorScheme;

    final pulinho = _t(loc, pt: 'Pular', en: 'Skip', es: 'Saltar');
    final proximo = _t(loc, pt: 'Próximo', en: 'Next', es: 'Siguiente');
    final comecar = _t(loc, pt: 'Começar', en: 'Get started', es: 'Empezar');

    final paginas = [
      _OnbPage(
        icone: Icons.qr_code_scanner_rounded,
        cor: scheme.primary,
        titulo: _t(loc,
            pt: 'Escaneie o QR perto do aquário',
            en: 'Scan the QR near the tank',
            es: 'Escanea el QR junto al acuario'),
        texto: _t(loc,
            pt: 'Em cada aquário você encontra um código QR. Aponte a câmera do celular pra abrir as informações da espécie.',
            en: 'Each tank has a QR code. Point your phone camera at it to open the species info.',
            es: 'Cada acuario tiene un código QR. Apunta la cámara para abrir la información de la especie.'),
      ),
      _OnbPage(
        icone: Icons.volume_up_rounded,
        cor: scheme.secondary,
        titulo: _t(loc,
            pt: 'Ouça em qualquer idioma',
            en: 'Listen in any language',
            es: 'Escucha en cualquier idioma'),
        texto: _t(loc,
            pt: 'Toque em "Ouvir" pra escutar a descrição falada. Troque o idioma no canto superior direito.',
            en: 'Tap "Listen" to hear the description aloud. Switch language in the top-right corner.',
            es: 'Toca "Escuchar" para oír la descripción. Cambia el idioma en la esquina superior derecha.'),
      ),
      _OnbPage(
        icone: Icons.eco_rounded,
        cor: Colors.teal,
        titulo: _t(loc,
            pt: 'Colete suas espécies',
            en: 'Collect your species',
            es: 'Colecciona tus especies'),
        texto: _t(loc,
            pt: 'Cada bicho que você visitar fica marcado no seu passaporte. Tente conhecer todos!',
            en: 'Every animal you visit is marked in your passport. Try to spot them all!',
            es: '¡Cada animal que visites queda marcado en tu pasaporte. Intenta conocerlos todos!'),
      ),
    ];

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  const LangSwitch(),
                  const Spacer(),
                  if (_page < paginas.length - 1)
                    TextButton(
                      onPressed: _concluir,
                      child: Text(pulinho),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                itemCount: paginas.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => paginas[i],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(paginas.length, (i) {
                      final ativo = i == _page;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: ativo ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: ativo
                              ? scheme.primary
                              : scheme.onSurface.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () {
                        if (_page == paginas.length - 1) {
                          _concluir();
                        } else {
                          _ctrl.nextPage(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                      child: Text(
                        _page == paginas.length - 1 ? comecar : proximo,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnbPage extends StatelessWidget {
  final IconData icone;
  final Color cor;
  final String titulo;
  final String texto;
  const _OnbPage({
    required this.icone,
    required this.cor,
    required this.titulo,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: cor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icone, size: 72, color: cor),
          ),
          const SizedBox(height: 40),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
              height: 1.2,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: scheme.onSurface.withOpacity(0.7),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
