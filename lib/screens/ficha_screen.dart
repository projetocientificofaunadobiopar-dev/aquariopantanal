import 'package:cached_network_image/cached_network_image.dart';
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
      final e = await SupabaseService()
          .buscarPorSlugOuId(widget.slugOrId)
          .timeout(const Duration(seconds: 8));
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
    final ttsLoc = e.houveFallback(loc) ? AppLocale.pt : loc;
    if (_falando) {
      await TtsService.instance.parar();
      setState(() => _falando = false);
    } else {
      setState(() => _falando = true);
      await TtsService.instance.falar(_textoParaTts(e, loc, s), loc: ttsLoc);
    }
  }

  void _abrirGaleria(Especie e) {
    if (e.imagemUrl == null) return;
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (_, __, ___) => _GaleriaViewer(
          tag: 'img_${e.id}',
          url: e.imagemUrl!,
          legenda: e.nomePopular(context.read<LocaleProvider>().locale),
        ),
      ),
    );
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

    final media = MediaQuery.of(context);
    final isCompact = media.size.width < 380;
    final hPad = isCompact ? 16.0 : 20.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Center(child: LangSwitch()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          hPad,
          12,
          hPad,
          120 + media.padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageCard(e, scheme),
            const SizedBox(height: 20),
            _tituloSecao(e, status, classe, loc),
            const SizedBox(height: 24),
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
              _bloco(context, s.expectativaVida, e.expectativaVida(loc)!,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _ttsFab(e, loc, s, scheme),
    );
  }

  Widget _imageCard(Especie e, ColorScheme scheme) {
    final media = MediaQuery.of(context);
    // Adapta à tela: 52% da altura, com piso/teto pra não ficar minúsculo
    // em landscape nem gigante em desktop.
    final maxH = (media.size.height * 0.52).clamp(220.0, 460.0);

    if (e.imagemUrl == null) {
      return Container(
        height: maxH * 0.7,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.image_not_supported_rounded,
          size: 48,
          color: scheme.onSurface.withOpacity(0.4),
        ),
      );
    }
    return Semantics(
      label: 'Toque para ampliar a foto',
      button: true,
      child: GestureDetector(
        onTap: () => _abrirGaleria(e),
        child: Container(
          constraints: BoxConstraints(maxHeight: maxH),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Hero(
                tag: 'img_${e.id}',
                child: CachedNetworkImage(
                  imageUrl: e.imagemUrl!,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  placeholder: (_, __) => SizedBox(
                    height: maxH * 0.7,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, __, ___) => SizedBox(
                    height: maxH * 0.7,
                    child: Icon(
                      Icons.broken_image_rounded,
                      size: 48,
                      color: scheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.zoom_out_map_rounded,
                          color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Ampliar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tituloSecao(
    Especie e,
    StatusConservacao? status,
    ClasseTaxonomica? classe,
    AppLocale loc,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (status != null) ...[
          _statusBadge(status, loc),
          const SizedBox(height: 14),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (classe != null) ...[
              ClasseAvatar(classe: classe, size: 40),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                e.nomePopular(loc),
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          e.nomeCientifico,
          style: TextStyle(
            color: scheme.onSurface.withOpacity(0.7),
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
              color: scheme.onSurface.withOpacity(0.55),
              fontSize: 13,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ],
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

class _GaleriaViewer extends StatefulWidget {
  final String tag;
  final String url;
  final String legenda;
  const _GaleriaViewer({
    required this.tag,
    required this.url,
    required this.legenda,
  });

  @override
  State<_GaleriaViewer> createState() => _GaleriaViewerState();
}

class _GaleriaViewerState extends State<_GaleriaViewer>
    with SingleTickerProviderStateMixin {
  final TransformationController _ctrl = TransformationController();
  late final AnimationController _zoomAnim;
  Animation<Matrix4>? _zoomTween;
  TapDownDetails? _doubleTapPos;

  double _dragY = 0;
  bool _dragging = false;

  bool get _zoomed => _ctrl.value.getMaxScaleOnAxis() > 1.05;

  @override
  void initState() {
    super.initState();
    _zoomAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(() {
        if (_zoomTween != null) _ctrl.value = _zoomTween!.value;
      });
    _ctrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _zoomAnim.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  void _toggleZoom() {
    HapticFeedback.lightImpact();
    Matrix4 target;
    if (_zoomed) {
      target = Matrix4.identity();
    } else {
      const zoom = 2.5;
      final pos = _doubleTapPos?.localPosition;
      if (pos != null) {
        target = Matrix4.identity()
          ..translate(-pos.dx * (zoom - 1), -pos.dy * (zoom - 1))
          ..scale(zoom);
      } else {
        target = Matrix4.identity()..scale(zoom);
      }
    }
    _zoomTween = Matrix4Tween(begin: _ctrl.value, end: target).animate(
      CurvedAnimation(parent: _zoomAnim, curve: Curves.easeOutCubic),
    );
    _zoomAnim
      ..reset()
      ..forward();
  }

  void _onDragUpdate(DragUpdateDetails d) {
    if (_zoomed) return;
    setState(() {
      _dragging = true;
      _dragY += d.delta.dy;
    });
  }

  void _onDragEnd(DragEndDetails d) {
    if (_zoomed) return;
    final velocity = d.primaryVelocity ?? 0;
    final shouldClose = _dragY.abs() > 120 || velocity.abs() > 600;
    if (shouldClose) {
      HapticFeedback.lightImpact();
      Navigator.of(context).pop();
    } else {
      setState(() {
        _dragY = 0;
        _dragging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final progress = (_dragY.abs() / 300).clamp(0.0, 1.0);
    final bgOpacity = 1.0 - progress * 0.7;
    final uiVisible = !_zoomed && !_dragging;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(bgOpacity),
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _zoomed ? null : () => Navigator.of(context).pop(),
              onDoubleTapDown: (d) => _doubleTapPos = d,
              onDoubleTap: _toggleZoom,
              onVerticalDragUpdate: _onDragUpdate,
              onVerticalDragEnd: _onDragEnd,
              child: Transform.translate(
                offset: Offset(0, _dragY),
                child: InteractiveViewer(
                  transformationController: _ctrl,
                  minScale: 1.0,
                  maxScale: 5.0,
                  child: Center(
                    child: Hero(
                      tag: widget.tag,
                      child: CachedNetworkImage(
                        imageUrl: widget.url,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                        errorWidget: (_, __, ___) => const Icon(
                          Icons.broken_image_rounded,
                          color: Colors.white54,
                          size: 64,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: media.padding.top + 8,
            right: 8,
            child: AnimatedOpacity(
              opacity: uiVisible ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  iconSize: 24,
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Fechar',
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: media.padding.bottom + 24,
            child: AnimatedOpacity(
              opacity: uiVisible ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.touch_app_rounded,
                          color: Colors.white70, size: 14),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          widget.legenda,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
