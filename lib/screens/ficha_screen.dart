import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../i18n/strings.dart';
import '../models/especie.dart';
import '../providers/locale_provider.dart';
import '../services/supabase_service.dart';
import '../services/tts_service.dart';
import '../widgets/classe_icon.dart';
import '../widgets/hero_image.dart';
import '../widgets/lang_switch.dart';

class FichaScreen extends StatefulWidget {
  final String slugOrId;
  final Especie? inicial;
  const FichaScreen({super.key, required this.slugOrId, this.inicial});

  @override
  State<FichaScreen> createState() => _FichaScreenState();
}

class _FichaScreenState extends State<FichaScreen>
    with SingleTickerProviderStateMixin {
  Especie? _e;
  String? _erro;
  bool _falando = false;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _e = widget.inicial;
    if (_e == null) _carregar();
  }

  @override
  void dispose() {
    _pulse.dispose();
    TtsService.instance.parar();
    super.dispose();
  }

  Future<void> _carregar() async {
    try {
      final e = await SupabaseService().buscarPorSlugOuId(widget.slugOrId);
      if (mounted) setState(() => _e = e);
    } catch (err) {
      if (mounted) setState(() => _erro = err.toString());
    }
  }

  String _textoParaTts(Especie e, AppLocale loc, Strings s) {
    final partes = <String>[
      e.nomePopular(loc),
      '${s.bioma}: ${e.bioma(loc)}',
      '${s.nicho}: ${e.nicho(loc)}',
    ];
    if (e.tamanho(loc)?.isNotEmpty == true) {
      partes.add('${s.tamanho}: ${e.tamanho(loc)}');
    }
    if (e.dieta(loc)?.isNotEmpty == true) {
      partes.add('${s.dieta}: ${e.dieta(loc)}');
    }
    if (e.expectativaVida(loc)?.isNotEmpty == true) {
      partes.add('${s.expectativaVida}: ${e.expectativaVida(loc)}');
    }
    if (e.ameacas(loc)?.isNotEmpty == true) {
      partes.add('${s.ameacas}: ${e.ameacas(loc)}');
    }
    if (e.curiosidade(loc)?.isNotEmpty == true) {
      partes.add('${s.curiosidade}: ${e.curiosidade(loc)}');
    }
    return partes.join('. ');
  }

  Future<void> _toggleFala(Especie e, AppLocale loc, Strings s) async {
    HapticFeedback.mediumImpact();
    // Sempre fala em PT se houver fallback, ou no idioma escolhido
    final ttsLoc = e.houveFallback(loc) ? AppLocale.pt : loc;
    if (_falando) {
      await TtsService.instance.parar();
      setState(() => _falando = false);
    } else {
      setState(() => _falando = true);
      await TtsService.instance.falar(_textoParaTts(e, loc, s), loc: ttsLoc);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocaleProvider>().locale;
    final s = Strings(loc);
    final scheme = Theme.of(context).colorScheme;

    if (_erro != null) {
      return Scaffold(
        appBar: AppBar(title: Text(s.erro)),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_erro!),
        ),
      );
    }
    if (_e == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final e = _e!;
    final status = e.statusEnum;
    final classe = e.classeEnum;
    final fb = e.houveFallback(loc);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            stretch: true,
            backgroundColor: scheme.surface,
            foregroundColor: Colors.white,
            leading: _CircleAction(
              icon: Icons.arrow_back_rounded,
              onTap: () => context.canPop() ? context.pop() : context.go('/'),
            ),
            actions: [
              _CircleAction(
                icon: null,
                child: const LangSwitch(foregroundColor: Colors.white),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  e.imagemUrl == null
                      ? Container(color: scheme.surfaceContainerHighest)
                      : HeroImage(
                          tag: 'img_${e.id}',
                          url: e.imagemUrl!,
                        ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.35),
                          Colors.transparent,
                          Colors.black.withOpacity(0.45),
                          Colors.black.withOpacity(0.92),
                        ],
                        stops: const [0, 0.35, 0.7, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (status != null) _statusBadge(status, loc),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            if (classe != null) ...[
                              ClasseAvatar(classe: classe, size: 36),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: Text(
                                e.nomePopular(loc),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                  letterSpacing: -0.5,
                                  shadows: [
                                    Shadow(
                                        blurRadius: 8,
                                        color: Colors.black54),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          e.nomeCientifico,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        if (classe != null || e.familia != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            [
                              if (classe != null) classe.label(loc),
                              if (e.familia != null) e.familia!,
                            ].join(' · '),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (fb) ...[
                    _fallbackBanner(context, s),
                    const SizedBox(height: 16),
                  ],
                  _bloco(context, s.bioma, e.bioma(loc),
                      Icons.public_rounded, scheme.primary),
                  _bloco(context, s.nicho, e.nicho(loc),
                      Icons.eco_rounded, scheme.primary),
                  if (e.tamanho(loc)?.isNotEmpty == true)
                    _bloco(context, s.tamanho, e.tamanho(loc)!,
                        Icons.straighten_rounded, scheme.primary),
                  if (e.dieta(loc)?.isNotEmpty == true)
                    _bloco(context, s.dieta, e.dieta(loc)!,
                        Icons.restaurant_rounded, scheme.primary),
                  if (e.expectativaVida(loc)?.isNotEmpty == true)
                    _bloco(context, s.expectativaVida,
                        e.expectativaVida(loc)!,
                        Icons.access_time_rounded, scheme.primary),
                  if (e.ameacas(loc)?.isNotEmpty == true)
                    _bloco(context, s.ameacas, e.ameacas(loc)!,
                        Icons.warning_amber_rounded, Colors.redAccent,
                        destaque: true),
                  if (e.curiosidade(loc)?.isNotEmpty == true)
                    _bloco(context, s.curiosidade, e.curiosidade(loc)!,
                        Icons.lightbulb_rounded, scheme.secondary,
                        destaque: true),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _ttsFab(e, loc, s, scheme),
    );
  }

  Widget _fallbackBanner(BuildContext context, Strings s) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.secondary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.secondary.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.translate_rounded, color: scheme.secondary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.traducaoPendente,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  s.traducaoPendenteDesc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withOpacity(0.75),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ttsFab(Especie e, AppLocale loc, Strings s, ColorScheme scheme) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) {
        final t = _falando ? _pulse.value : 0.0;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withOpacity(0.35 + 0.25 * t),
                blurRadius: 16 + 10 * t,
                spreadRadius: 1 + 3 * t,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => _toggleFala(e, loc, s),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _falando
                          ? Icons.stop_rounded
                          : Icons.volume_up_rounded,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _falando ? s.parar : s.ouvir,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _statusBadge(StatusConservacao st, AppLocale loc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(st.cor),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Color(st.cor).withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(st.codigo,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 0.8,
              )),
          const SizedBox(width: 8),
          Text(st.label(loc),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }

  Widget _bloco(
    BuildContext context,
    String titulo,
    String texto,
    IconData ic,
    Color cor, {
    bool destaque = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: destaque
              ? cor.withOpacity(isDark ? 0.15 : 0.08)
              : scheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: destaque
                ? cor.withOpacity(0.25)
                : scheme.onSurface.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(ic, color: cor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        letterSpacing: 0.2,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(texto, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? child;
  const _CircleAction({this.icon, this.onTap, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.black.withOpacity(0.4),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: child ??
                Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}
