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
      backgroundColor: Colors.black,
      body: HeroBackground(
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
                    const SizedBox(height: 32),
                    _WelcomeHeader(s: s),
                    const SizedBox(height: 36),
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
            color: Colors.white.withOpacity(0.18),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Scaffold.of(ctx).openDrawer(),
              child: const SizedBox(
                width: 46,
                height: 46,
                child: Icon(Icons.menu_rounded, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.5),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.water_drop_rounded,
              color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BIOPARQUE',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.2,
                ),
              ),
              Text(
                'Pantanal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        const LangSwitch(foregroundColor: Colors.white),
        const ThemeToggle(foregroundColor: Colors.white),
      ],
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  final Strings s;
  const _WelcomeHeader({required this.s});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 2.5,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                s.welcomeOver,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w800,
                  fontSize: 11.5,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Título grande — contraste máximo (branco puro sobre overlay escuro)
        Text(
          s.welcomeTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 38,
            height: 1.08,
            letterSpacing: -1,
            fontWeight: FontWeight.w800,
            // Sombra leve pra reforçar legibilidade caso parte da imagem
            // por trás fique clara em algum momento.
            shadows: [
              Shadow(
                blurRadius: 12,
                color: Colors.black54,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          s.welcomeSubtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.92),
            fontSize: 16,
            height: 1.55,
            shadows: const [
              Shadow(blurRadius: 8, color: Colors.black38),
            ],
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
    final color = Colors.white.withOpacity(0.25);
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0), color, color.withOpacity(0)],
        ),
      ),
    );
  }
}

/// Card de ação com Liquid Glass refinado, otimizado para legibilidade
/// sobre o fundo escuro (texto branco + ícone em círculo outline).
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
      tint: Colors.white,
      blur: 28,
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
                    color: accent.withOpacity(0.22),
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
          const SizedBox(height: 22),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              height: 1.15,
              letterSpacing: -0.3,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              height: 1.55,
              fontSize: 14.5,
              color: Colors.white.withOpacity(0.88),
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
                  fontSize: 14,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Ícone refinado: círculo glass com ícone vazado dentro.
class _RefinedIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _RefinedIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.5),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}

class _ConhecerFaunaCard extends StatelessWidget {
  final Strings s;
  const _ConhecerFaunaCard({required this.s});

  @override
  Widget build(BuildContext context) {
    return _ActionCard(
      icon: Icons.spa_outlined,
      accent: AppColors.primaryLight,
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
    return _ActionCard(
      icon: Icons.qr_code_scanner_outlined,
      accent: AppColors.accent,
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
            const SizedBox(height: 16),
            Text(
              s.subtituloFauna,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.3,
                color: Colors.white.withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
