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
              final wide = c.maxWidth >= 800;
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopBar(),
                    const SizedBox(height: 12),
                    _WelcomeHeader(s: s),
                    const SizedBox(height: 24),
                    const PwaInstallBanner(),
                    const SizedBox(height: 8),
                    if (wide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _ConhecerFaunaCard(s: s)),
                          const SizedBox(width: 18),
                          Expanded(child: _ScanCard(s: s)),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _ConhecerFaunaCard(s: s),
                          const SizedBox(height: 18),
                          _ScanCard(s: s),
                        ],
                      ),
                    const SizedBox(height: 28),
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
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Builder(
          builder: (ctx) => Material(
            color: Colors.white.withOpacity(0.4),
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
        const SizedBox(width: 10),
        Container(
          width: 40,
          height: 40,
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
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'Pantanal',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800, height: 1),
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
        Text(
          s.welcomeOver,
          style: TextStyle(
            color: scheme.primary,
            fontWeight: FontWeight.w800,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          s.welcomeTitle,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                height: 1.05,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          s.welcomeSubtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: scheme.onSurface.withOpacity(0.7),
                height: 1.5,
              ),
        ),
      ],
    );
  }
}

class _ConhecerFaunaCard extends StatelessWidget {
  final Strings s;
  const _ConhecerFaunaCard({required this.s});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LiquidGlassCard(
      onTap: () => context.push('/fauna'),
      radiusVariant: 0,
      padding: const EdgeInsets.all(22),
      tint: scheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      scheme.primary,
                      scheme.primary.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: LiquidGlass.organic(variant: 2, scale: 0.7),
                ),
                child: const Icon(
                  Icons.spa_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_outward_rounded,
                  color: scheme.primary, size: 28),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            s.acConhecerTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            s.acConhecerSub,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.75),
                ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                s.acConhecerCTA,
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right_rounded,
                  color: scheme.primary, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScanCard extends StatelessWidget {
  final Strings s;
  const _ScanCard({required this.s});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LiquidGlassCard(
      onTap: () => context.push('/scan'),
      radiusVariant: 1,
      padding: const EdgeInsets.all(22),
      tint: scheme.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      scheme.secondary,
                      scheme.secondary.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: LiquidGlass.organic(variant: 3, scale: 0.7),
                ),
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: scheme.secondary.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  Strings(context.watch<LocaleProvider>().locale)
                      .loc
                      .code
                      .toUpperCase(),
                  style: TextStyle(
                    color: scheme.secondary,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            s.acScanTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            s.acScanSub,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.75),
                ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                s.acScanCTA,
                style: TextStyle(
                  color: scheme.secondary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right_rounded,
                  color: scheme.secondary, size: 20),
            ],
          ),
        ],
      ),
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
        child: Text(
          s.subtituloFauna,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 13,
            color:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
          ),
        ),
      ),
    );
  }
}
