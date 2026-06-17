import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../i18n/strings.dart';
import '../models/especie.dart';
import '../providers/locale_provider.dart';
import '../services/supabase_service.dart';
import '../theme/liquid_glass.dart';
import '../widgets/app_drawer.dart';
import '../widgets/classe_icon.dart';
import '../widgets/especie_card.dart';
import '../widgets/especie_card_skeleton.dart';
import '../widgets/lang_switch.dart';

const List<Map<String, dynamic>> _demoEspecies = [
  {
    'id': 'demo-1',
    'slug': 'sucuri-verde',
    'nome_popular_pt': 'Sucuri-verde',
    'nome_popular_en': 'Green Anaconda',
    'nome_popular_es': 'Anaconda verde',
    'nome_cientifico': 'Eunectes murinus',
    'bioma_origem_pt': 'Pantanal e Amazônia',
    'bioma_origem_en': 'Pantanal and Amazon',
    'bioma_origem_es': 'Pantanal y Amazonía',
    'nicho_ecologico_pt':
        'Predadora de topo em ambientes alagados, controla populações de capivaras e jacarés jovens.',
    'nicho_ecologico_en':
        'Apex predator in flooded environments, controls capybara and young caiman populations.',
    'nicho_ecologico_es':
        'Depredador tope en ambientes inundados, controla poblaciones de capibaras y caimanes jóvenes.',
    'imagem_url':
        'https://images.unsplash.com/photo-1583499871880-de841d1ace2a?w=800',
    'classe': 'reptil',
    'status_conservacao': 'LC',
  },
  {
    'id': 'demo-2',
    'slug': 'jacare-do-pantanal',
    'nome_popular_pt': 'Jacaré-do-pantanal',
    'nome_popular_en': 'Yacare Caiman',
    'nome_popular_es': 'Yacaré',
    'nome_cientifico': 'Caiman yacare',
    'bioma_origem_pt': 'Pantanal',
    'bioma_origem_en': 'Pantanal wetlands',
    'bioma_origem_es': 'Humedales del Pantanal',
    'nicho_ecologico_pt':
        'Predador oportunista, alimenta-se principalmente de peixes e mantém o equilíbrio ecológico.',
    'nicho_ecologico_en':
        'Opportunistic predator, feeds mainly on fish and maintains ecological balance.',
    'nicho_ecologico_es':
        'Depredador oportunista, se alimenta principalmente de peces y mantiene el equilibrio ecológico.',
    'imagem_url':
        'https://images.unsplash.com/photo-1599842057874-37393e9342df?w=800',
    'classe': 'reptil',
    'status_conservacao': 'LC',
  },
  {
    'id': 'demo-3',
    'slug': 'axolote',
    'nome_popular_pt': 'Axolote',
    'nome_popular_en': 'Axolotl',
    'nome_popular_es': 'Ajolote',
    'nome_cientifico': 'Ambystoma mexicanum',
    'bioma_origem_pt': 'Lagos do México',
    'bioma_origem_en': 'Mexican lakes',
    'bioma_origem_es': 'Lagos de México',
    'nicho_ecologico_pt':
        'Anfíbio neotênico que mantém características larvais por toda a vida; capacidade impressionante de regeneração.',
    'nicho_ecologico_en':
        'Neotenic amphibian that keeps larval features for life; remarkable regeneration ability.',
    'nicho_ecologico_es':
        'Anfibio neoténico que mantiene rasgos larvales toda la vida; capacidad impresionante de regeneración.',
    'imagem_url':
        'https://images.unsplash.com/photo-1623211770519-aef3f4795db5?w=800',
    'classe': 'anfibio',
    'status_conservacao': 'CR',
  },
];

class FaunaScreen extends StatefulWidget {
  const FaunaScreen({super.key});

  @override
  State<FaunaScreen> createState() => _FaunaScreenState();
}

class _FaunaScreenState extends State<FaunaScreen> {
  late Future<List<Especie>> _future;
  final _svc = SupabaseService();
  final _searchCtrl = TextEditingController();
  String _busca = '';
  ClasseTaxonomica? _filtroClasse;

  @override
  void initState() {
    super.initState();
    _future = _carregarComFallback();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<List<Especie>> _carregarComFallback() async {
    try {
      final list =
          await _svc.listar().timeout(const Duration(seconds: 5));
      if (list.isNotEmpty) return list;
    } catch (_) {}
    return _demoEspecies.map(Especie.fromMap).toList();
  }

  Future<void> _recarregar() async {
    setState(() => _future = _carregarComFallback());
  }

  List<Especie> _filtrar(List<Especie> list, AppLocale loc) {
    final b = _busca.trim().toLowerCase();
    return list.where((e) {
      if (_filtroClasse != null && e.classeEnum != _filtroClasse) return false;
      if (b.isEmpty) return true;
      return e.nomePopular(loc).toLowerCase().contains(b) ||
          e.nomeCientifico.toLowerCase().contains(b);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocaleProvider>().locale;
    final s = Strings(loc);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: AppDrawer(
        categoriaSelecionada: _filtroClasse,
        onSelectCategoria: (c) => setState(() => _filtroClasse = c),
      ),
      backgroundColor: Colors.transparent,
      body: LiquidBackground(
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: _recarregar,
            child: FutureBuilder<List<Especie>>(
              future: _future,
              builder: (ctx, snap) {
                final loading =
                    snap.connectionState == ConnectionState.waiting;
                final all = snap.data ?? [];
                final list = _filtrar(all, loc);

                return AnimationLimiter(
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      _Header(s: s, total: all.length),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        sliver: SliverToBoxAdapter(
                          child: _SearchField(
                            controller: _searchCtrl,
                            hint: s.buscar,
                            onChanged: (v) => setState(() => _busca = v),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _ClasseChips(
                          selecionada: _filtroClasse,
                          loc: loc,
                          sTodos: s.todos,
                          onChange: (c) => setState(() => _filtroClasse = c),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                      if (loading)
                        _gridShimmer(scheme)
                      else if (snap.hasError)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child:
                              _ErrorState(msg: '${s.erro}: ${snap.error}'),
                        )
                      else if (list.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _EmptyState(
                            msg: all.isEmpty
                                ? s.nenhumaEspecie
                                : s.nenhumResultado,
                            actionLabel:
                                all.isEmpty ? null : s.limparFiltros,
                            onAction: all.isEmpty
                                ? null
                                : () {
                                    setState(() {
                                      _filtroClasse = null;
                                      _busca = '';
                                      _searchCtrl.clear();
                                    });
                                  },
                          ),
                        )
                      else
                        SliverPadding(
                          padding:
                              const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          sliver: SliverLayoutBuilder(
                            builder: (ctx, c) {
                              final w = c.crossAxisExtent;
                              final cross = w < 480
                                  ? 2
                                  : w < 800
                                      ? 3
                                      : w < 1200
                                          ? 4
                                          : 5;
                              return SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: cross,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (_, i) =>
                                      AnimationConfiguration.staggeredGrid(
                                    position: i,
                                    duration: const Duration(
                                        milliseconds: 450),
                                    columnCount: cross,
                                    child: ScaleAnimation(
                                      scale: 0.92,
                                      child: FadeInAnimation(
                                        child: EspecieCard(
                                          especie: list[i],
                                          loc: loc,
                                          onTap: () {
                                            final slug = list[i].slug ??
                                                list[i].id;
                                            context.push(
                                                '/especie/$slug',
                                                extra: list[i]);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  childCount: list.length,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: _ScanFab(s: s),
    );
  }

  Widget _gridShimmer(ColorScheme scheme) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      sliver: SliverLayoutBuilder(
        builder: (ctx, c) {
          final w = c.crossAxisExtent;
          final cross = w < 480 ? 2 : (w < 800 ? 3 : 4);
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cross,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, __) => const EspecieCardSkeleton(),
              childCount: cross * 2,
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Strings s;
  final int total;
  const _Header({required this.s, required this.total});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
                Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    tooltip: 'Voltar',
                    onPressed: () => ctx.canPop()
                        ? ctx.pop()
                        : ctx.go('/'),
                  ),
                ),
                const Spacer(),
                const LangSwitch(),
                const ThemeToggle(),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.tituloFauna,
                      style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 4),
                  Text(
                    s.subtituloFauna,
                    style:
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: scheme.onSurface.withOpacity(0.65),
                            ),
                  ),
                  if (total > 0) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: scheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '$total ${s.especies}',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              ),
      ),
    );
  }
}

class _ClasseChips extends StatelessWidget {
  final ClasseTaxonomica? selecionada;
  final AppLocale loc;
  final String sTodos;
  final ValueChanged<ClasseTaxonomica?> onChange;
  const _ClasseChips({
    required this.selecionada,
    required this.loc,
    required this.sTodos,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget chip(Widget? icon, String label, bool sel, VoidCallback onTap) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: sel ? scheme.primary : scheme.surface.withOpacity(0.55),
              borderRadius: LiquidGlass.dropPill(),
              border: Border.all(
                color: sel
                    ? scheme.primary
                    : Colors.white.withOpacity(0.5),
                width: 1,
              ),
              boxShadow: sel
                  ? [
                      BoxShadow(
                        color: scheme.primary.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      size: 16,
                      color: sel ? Colors.white : null,
                    ),
                    child: icon,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: sel ? Colors.white : scheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          chip(null, sTodos, selecionada == null, () => onChange(null)),
          ...ClasseTaxonomica.values.map(
            (c) => chip(
              ClasseIcon(classe: c, size: 16),
              c.label(loc),
              selecionada == c,
              () => onChange(c),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String msg;
  final String? actionLabel;
  final VoidCallback? onAction;
  const _EmptyState({required this.msg, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search_off_rounded,
                  size: 40, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(msg,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            if (actionLabel != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String msg;
  const _ErrorState({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(msg, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ScanFab extends StatelessWidget {
  final Strings s;
  const _ScanFab({required this.s});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withOpacity(0.45),
            blurRadius: 18,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.large(
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        tooltip: s.escanear,
        onPressed: () => context.push('/scan'),
        child: const Icon(Icons.qr_code_scanner_rounded, size: 32),
      ),
    );
  }
}
