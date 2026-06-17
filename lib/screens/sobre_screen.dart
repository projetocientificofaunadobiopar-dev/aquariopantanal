import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../widgets/app_icons.dart';

import '../i18n/strings.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings(context.watch<LocaleProvider>().locale);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            stretch: true,
            backgroundColor: scheme.surface,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () =>
                  context.canPop() ? context.pop() : context.go('/'),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [AppColors.darkSurface, AppColors.darkBg]
                        : [
                            AppColors.primary,
                            AppColors.primaryLight,
                            AppColors.accent.withOpacity(0.7),
                          ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3)),
                            ),
                            child: const Icon(
                              Icons.water_drop_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Bioparque Pantanal',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            'Campo Grande · MS',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.bioparqueDescricao,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  _Cards(s: s),
                  const SizedBox(height: 24),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        s.sobreCreditos,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: scheme.onSurface.withOpacity(0.5),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Cards extends StatelessWidget {
  final Strings s;
  const _Cards({required this.s});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocaleProvider>().locale;
    return Column(
      children: [
        _InfoCard(
          icon: AppIcons.locationDot,
          title: loc == AppLocale.en
              ? 'Location'
              : loc == AppLocale.es
                  ? 'Ubicación'
                  : 'Localização',
          subtitle: 'Av. Afonso Pena, 6001\nChácara Cachoeira, Campo Grande - MS',
        ),
        _InfoCard(
          icon: AppIcons.clock,
          title: loc == AppLocale.en
              ? 'Hours'
              : loc == AppLocale.es
                  ? 'Horarios'
                  : 'Horários',
          subtitle: loc == AppLocale.en
              ? 'Tuesday to Sunday · 8h – 17h'
              : loc == AppLocale.es
                  ? 'Martes a domingo · 8h – 17h'
                  : 'Terça a domingo · 8h – 17h',
        ),
        _InfoCard(
          icon: AppIcons.fish,
          title: loc == AppLocale.en
              ? 'World\'s largest freshwater aquarium'
              : loc == AppLocale.es
                  ? 'El acuario de agua dulce más grande del mundo'
                  : 'Maior aquário de água doce do mundo',
          subtitle: loc == AppLocale.en
              ? 'Over 30 tanks and 263 species'
              : loc == AppLocale.es
                  ? 'Más de 30 tanques y 263 especies'
                  : 'Mais de 30 tanques e 263 espécies',
        ),
        _InfoCard(
          icon: AppIcons.graduationCap,
          title: loc == AppLocale.en
              ? 'Environmental education'
              : loc == AppLocale.es
                  ? 'Educación ambiental'
                  : 'Educação ambiental',
          subtitle: loc == AppLocale.en
              ? 'Programs for schools and the community'
              : loc == AppLocale.es
                  ? 'Programas para escuelas y la comunidad'
                  : 'Programas para escolas e a comunidade',
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: scheme.onSurface.withOpacity(0.08),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: scheme.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface.withOpacity(0.7),
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
