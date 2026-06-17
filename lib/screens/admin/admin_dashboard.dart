import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../i18n/strings.dart';
import '../../models/especie.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../services/supabase_service.dart';
import '../../widgets/classe_icon.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _svc = SupabaseService();
  late Future<List<Especie>> _future;
  final _searchCtrl = TextEditingController();
  String _busca = '';
  bool _soIncompletas = false;

  @override
  void initState() {
    super.initState();
    _future = _svc.listar();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _recarregar() {
    setState(() => _future = _svc.listar());
  }

  bool _incompleta(Especie e) =>
      !e.temImagem || !e.completoEn || !e.completoEs;

  List<Especie> _filtrar(List<Especie> list) {
    final b = _busca.trim().toLowerCase();
    return list.where((e) {
      if (_soIncompletas && !_incompleta(e)) return false;
      if (b.isEmpty) return true;
      return e.nomePopularPt.toLowerCase().contains(b) ||
          e.nomeCientifico.toLowerCase().contains(b);
    }).toList();
  }

  Future<void> _confirmarExcluir(Especie e, Strings s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(s.confirmarExclusao),
        content: Text(e.nomePopularPt),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(s.cancelar),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: Text(s.excluir),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _svc.deletar(e.id);
      _recarregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings(context.watch<LocaleProvider>().locale);
    final loc = context.watch<LocaleProvider>().locale;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: scheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.tune_rounded,
                        color: scheme.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ADMIN',
                            style: TextStyle(
                              color: scheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            )),
                        Text(s.admin,
                            style:
                                Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: s.logout,
                    icon: const Icon(Icons.logout_rounded),
                    onPressed: () async {
                      await context.read<AuthProvider>().logout();
                      if (mounted) context.go('/');
                    },
                  ),
                ],
              ),
            ),
            // Busca
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _busca = v),
                decoration: InputDecoration(
                  hintText: s.buscar,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _busca.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _busca = '');
                          },
                        ),
                ),
              ),
            ),
            // Filtro incompletas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  FilterChip(
                    selected: _soIncompletas,
                    label: Text(s.loc == AppLocale.en
                        ? 'Only incomplete'
                        : s.loc == AppLocale.es
                            ? 'Solo incompletas'
                            : 'Só incompletas'),
                    avatar: Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: _soIncompletas
                          ? Colors.white
                          : Colors.orange,
                    ),
                    selectedColor: Colors.orange,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      color: _soIncompletas ? Colors.white : null,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (v) =>
                        setState(() => _soIncompletas = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Especie>>(
                future: _future,
                builder: (ctx, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Center(
                        child: Text('${s.erro}: ${snap.error}'));
                  }
                  final all = snap.data ?? [];
                  final list = _filtrar(all);
                  if (all.isEmpty) {
                    return _emptyAdmin(s, scheme);
                  }
                  if (list.isEmpty) {
                    return Center(
                      child: Text(s.nenhumResultado,
                          style: Theme.of(context).textTheme.titleMedium),
                    );
                  }
                  return ListView.separated(
                    padding:
                        const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: list.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (_, i) =>
                        _row(list[i], s, loc, scheme),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final r = await context.push('/admin/form');
          if (r == true) _recarregar();
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(s.novo,
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _row(Especie e, Strings s, AppLocale loc, ColorScheme scheme) {
    final status = e.statusEnum;
    final classe = e.classeEnum;
    final missing = <_Badge>[];
    if (!e.temImagem) {
      missing.add(_Badge(
        icon: Icons.image_not_supported_outlined,
        label: s.semImagem,
        color: Colors.orange.shade700,
      ));
    }
    if (!e.completoEn) {
      missing.add(_Badge(
        icon: Icons.translate_rounded,
        label: '🇺🇸 ${s.semTraducao}',
        color: Colors.blue.shade700,
      ));
    }
    if (!e.completoEs) {
      missing.add(_Badge(
        icon: Icons.translate_rounded,
        label: '🇪🇸 ${s.semTraducao}',
        color: Colors.purple.shade700,
      ));
    }
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          final r = await context.push('/admin/form', extra: e);
          if (r == true) _recarregar();
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: e.imagemUrl != null
                      ? CachedNetworkImage(
                          imageUrl: e.imagemUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: scheme.surfaceContainerHighest,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: scheme.surfaceContainerHighest,
                            child: const Icon(Icons.broken_image),
                          ),
                        )
                      : Container(
                          color: scheme.surfaceContainerHighest,
                          child: Icon(Icons.pets,
                              color: scheme.onSurface.withOpacity(0.4)),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (classe != null) ...[
                          ClasseIcon(classe: classe, size: 16),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            e.nomePopularPt,
                            style:
                                Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      e.nomeCientifico,
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: scheme.onSurface.withOpacity(0.6),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (e.slug != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '/${e.slug}',
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          color: scheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (status != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color:
                                  Color(status.cor).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                  color: Color(status.cor).withOpacity(0.4),
                                  width: 1),
                            ),
                            child: Text(
                              status.codigo,
                              style: TextStyle(
                                color: Color(status.cor),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ...missing,
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: s.excluir,
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent),
                onPressed: () => _confirmarExcluir(e, s),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyAdmin(Strings s, ColorScheme scheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.pets_rounded,
                  size: 44, color: scheme.primary),
            ),
            const SizedBox(height: 18),
            Text(s.nenhumaEspecie,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                final r = await context.push('/admin/form');
                if (r == true) _recarregar();
              },
              icon: const Icon(Icons.add_rounded),
              label: Text(s.novo),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Badge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
