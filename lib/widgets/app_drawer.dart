import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app_icons.dart';

import '../i18n/strings.dart';
import '../models/especie.dart';
import '../providers/locale_provider.dart';
import '../providers/text_scale_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import 'classe_icon.dart';

class AppDrawer extends StatelessWidget {
  /// Categoria atualmente selecionada na home (para destacar no menu).
  final ClasseTaxonomica? categoriaSelecionada;
  final ValueChanged<ClasseTaxonomica?>? onSelectCategoria;
  const AppDrawer({
    super.key,
    this.categoriaSelecionada,
    this.onSelectCategoria,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocaleProvider>().locale;
    final s = Strings(loc);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    void close() => Navigator.of(context).pop();

    return Drawer(
      backgroundColor: scheme.surface,
      width: 320,
      child: SafeArea(
        child: Column(
          children: [
            _Brand(isDark: isDark),
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _section(s.menu),
                  _MenuTile(
                    icon: AppIcons.house,
                    label: s.inicio,
                    onTap: () {
                      close();
                      context.go('/');
                    },
                  ),
                  _MenuTile(
                    icon: Icons.spa_rounded,
                    label: s.acConhecerTitle,
                    onTap: () {
                      onSelectCategoria?.call(null);
                      close();
                      context.push('/fauna');
                    },
                    active: categoriaSelecionada == null && onSelectCategoria != null,
                  ),
                  _MenuTile(
                    icon: Icons.qr_code_scanner_rounded,
                    label: s.escanear,
                    onTap: () {
                      close();
                      context.push('/scan');
                    },
                  ),
                  _MenuTile(
                    icon: AppIcons.circleInfo,
                    label: s.sobre,
                    onTap: () {
                      close();
                      context.push('/sobre');
                    },
                  ),
                  const SizedBox(height: 8),
                  _section(s.categorias),
                  ...ClasseTaxonomica.values.map((c) {
                    final data = ClasseIconData.of(c);
                    final active = categoriaSelecionada == c;
                    return _MenuTile(
                      iconWidget: SizedBox(
                        width: 22,
                        height: 22,
                        child: ClasseIcon(classe: c, size: 22),
                      ),
                      iconColor: data.color,
                      label: c.label(loc),
                      onTap: () {
                        if (onSelectCategoria != null) {
                          onSelectCategoria!(c);
                          close();
                        } else {
                          close();
                          context.push('/fauna');
                        }
                      },
                      active: active,
                    );
                  }),
                  // Acesso ao admin e login NÃO aparecem no menu.
                  // Acesso somente via URL direta /#/login → /#/admin.
                ],
              ),
            ),
            const Divider(height: 1),
            _TextScaleRow(s: s),
            _BottomRow(s: s),
          ],
        ),
      ),
    );
  }

  Widget _section(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
          color: AppColors.slate,
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  final bool isDark;
  const _Brand({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.darkSurface, AppColors.darkBg]
              : [
                  AppColors.primary.withOpacity(0.12),
                  AppColors.accent.withOpacity(0.06),
                ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.water_drop_rounded,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BIOPARQUE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.85),
                  ),
                ),
                Text(
                  'Pantanal',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(height: 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final Color? iconColor;
  final String label;
  final VoidCallback onTap;
  final bool active;
  const _MenuTile({
    this.icon,
    this.iconWidget,
    this.iconColor,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: active ? scheme.primary.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: (iconColor ?? scheme.primary).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: iconWidget ??
                      Icon(
                        icon,
                        size: 18,
                        color: iconColor ?? scheme.primary,
                      ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 14,
                      color: active ? scheme.primary : scheme.onSurface,
                    ),
                  ),
                ),
                if (active)
                  Icon(Icons.chevron_right_rounded, color: scheme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TextScaleRow extends StatelessWidget {
  final Strings s;
  const _TextScaleRow({required this.s});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<TextScaleProvider>();
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              s.tamanhoTexto,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          IconButton(
            tooltip: 'A-',
            onPressed: p.podeDiminuir
                ? () => context.read<TextScaleProvider>().diminuir()
                : null,
            icon: const Text('A',
                style: TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 13)),
          ),
          Container(
            width: 36,
            alignment: Alignment.center,
            child: Text(
              '${(p.scale * 100).round()}%',
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            tooltip: 'A+',
            onPressed: p.podeAumentar
                ? () => context.read<TextScaleProvider>().aumentar()
                : null,
            icon: const Text('A',
                style: TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 19)),
          ),
        ],
      ),
    );
  }
}

class _BottomRow extends StatelessWidget {
  final Strings s;
  const _BottomRow({required this.s});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final loc = context.watch<LocaleProvider>().locale;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.read<ThemeProvider>().toggle(),
              icon: Icon(
                isDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                size: 18,
              ),
              label: Text(isDark ? s.temaClaro : s.temaEscuro),
            ),
          ),
          const SizedBox(width: 8),
          _LangButton(loc: loc),
        ],
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final AppLocale loc;
  const _LangButton({required this.loc});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppLocale>(
      tooltip: 'Idioma',
      offset: const Offset(0, -160),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)),
      onSelected: (l) => context.read<LocaleProvider>().set(l),
      itemBuilder: (_) => AppLocale.values
          .map((l) => PopupMenuItem(
                value: l,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l.flag, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 10),
                    Text(l.nativeName,
                        style: TextStyle(
                          fontWeight: l == loc
                              ? FontWeight.w800
                              : FontWeight.w500,
                        )),
                    if (l == loc) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.check_rounded,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary),
                    ],
                  ],
                ),
              ))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.18)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(loc.flag, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              loc.shortLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
