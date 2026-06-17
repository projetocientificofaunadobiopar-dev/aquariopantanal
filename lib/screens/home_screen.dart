import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../i18n/strings.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';
import '../theme/liquid_glass.dart';
import '../widgets/app_drawer.dart';
import '../widgets/lang_switch.dart';
import '../widgets/pwa_install_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocaleProvider>().locale;
    final s = Strings(loc);

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.transparent,
      body: LiquidBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (ctx, c) {
              final wide = c.maxWidth >= 820;
              final h = c.maxWidth >= 600 ? 28.0 : 20.0;
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(h, 8, h, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _TopBar(),
                    const SizedBox(height: 28),
                    _WelcomeHeader(s: s),
                    const SizedBox(height: 28),
                    const _Hairline(),
                    const SizedBox(height: 28),
                    const PwaInstallBanner(),
                    if (wide)
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: _ConhecerFaunaCard(s: s)),
                            const SizedBox(width: 20),
                            Expanded(child: _ScanCard(s: s)),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: [
                          _ConhecerFaunaCard(s: s),
                          const SizedBox(height: 16),
                          _ScanCard(s: s),
                        ],
                      ),
                    const SizedBox(height: 36),
                    _FooterHint(s: s),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Builder(
          builder: (ctx) => Material(
            color: Colors.white.withOpacity(0.45),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Scaffold.of(ctx).openDrawer(),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(Icons.menu_rounded),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.water_drop_rounded,
              color: Colors.white, size: 22),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BIOPARQUE',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.2,
                ),
              ),
              Text(
                'Pantanal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        const LangSwitch(),
        const ThemeToggle(),
      ],
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  final Strings s;
  const _WelcomeHeader({required this.s});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 2,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                s.welcomeOver,
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          s.welcomeTitle,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 34,
                height: 1.1,
                letterSpacing: -0.8,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          s.welcomeSubtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: scheme.onSurface.withOpacity(0.7),
                height: 1.55,
                fontSize: 15,
              ),
        ),
      ],
    );
  }
}

class _Hairline extends StatelessWidget {
  const _Hairline();

  @override
  Widget build(BuildContext context) {
    final color =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.12);
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0), color, color.withOpacity(0)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Card de ação base: ícone refinado em círculo outline + título + microcopy + CTA.
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String title;
  final String description;
  final String cta;
  final int radiusVariant;
  final VoidCallback onTap;
  final String? badge;

  const _ActionCard({
    required this.icon,
    required this.accent,
    required this.title,
    required this.description,
    required this.cta,
    required this.radiusVariant,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      onTap: onTap,
      radiusVariant: radiusVariant,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
      tint: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _RefinedIcon(icon: icon, color: accent),
              const Spacer(),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  height: 1.15,
                  letterSpacing: -0.3,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.55,
                  fontSize: 14,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.72),
                ),
          ),
          const Spacer(),
          const SizedBox(height: 22),
          Row(
            children: [
              Text(
                cta,
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: accent,
                  size: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Ícone refinado: círculo outline com ícone vazado dentro (mais "luxury").
class _RefinedIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _RefinedIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.35), width: 1.2),
      ),
      child: Icon(icon, color: color, size: 26),
    );
  }
}

class _ConhecerFaunaCard extends StatelessWidget {
  final Strings s;
  const _ConhecerFaunaCard({required this.s});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _ActionCard(
      icon: Icons.spa_outlined,
      accent: scheme.primary,
      title: s.acConhecerTitle,
      description: s.acConhecerSub,
      cta: s.acConhecerCTA,
      radiusVariant: 0,
      onTap: () => context.push('/fauna'),
    );
  }
}

class _ScanCard extends StatelessWidget {
  final Strings s;
  const _ScanCard({required this.s});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _ActionCard(
      icon: Icons.qr_code_scanner_outlined,
      accent: scheme.secondary,
      title: s.acScanTitle,
      description: s.acScanSub,
      cta: s.acScanCTA,
      radiusVariant: 1,
      onTap: () => context.push('/scan'),
      badge: s.loc.code.toUpperCase(),
    );
  }
}

class _FooterHint extends StatelessWidget {
  final Strings s;
  const _FooterHint({required this.s});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const _Hairline(),
            const SizedBox(height: 14),
            Text(
              s.subtituloFauna,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                letterSpacing: 0.3,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
