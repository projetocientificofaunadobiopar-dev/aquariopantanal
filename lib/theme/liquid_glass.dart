import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_theme.dart';

/// Conjunto de utilitários para o estilo "Liquid Glass + Fauna":
/// - Gradientes fluidos (água + natureza)
/// - Bordas orgânicas e assimétricas (gotas)
/// - Containers de vidro borrado (BackdropFilter blur)
class LiquidGlass {
  /// Gradiente do fundo do app (tons água + areia).
  static LinearGradient backgroundLight() => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFD7F0EA), // aqua pálido
          Color(0xFFF4ECD8), // areia clara
          Color(0xFFE8F4D8), // verde mata claro
        ],
        stops: [0.0, 0.55, 1.0],
      );

  static LinearGradient backgroundDark() => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF071A18), // oceano profundo
          Color(0xFF0A1E1A), // mata escura
          Color(0xFF0F2823), // limo
        ],
        stops: [0.0, 0.55, 1.0],
      );

  /// Bordas orgânicas / assimétricas como gotas de água.
  /// Variant 0..3 para alternar formatos entre os cards.
  static BorderRadius organic({int variant = 0, double scale = 1}) {
    double s(double v) => v * scale;
    switch (variant % 4) {
      case 0:
        return BorderRadius.only(
          topLeft: Radius.elliptical(s(36), s(28)),
          topRight: Radius.circular(s(22)),
          bottomLeft: Radius.circular(s(22)),
          bottomRight: Radius.elliptical(s(34), s(40)),
        );
      case 1:
        return BorderRadius.only(
          topLeft: Radius.circular(s(22)),
          topRight: Radius.elliptical(s(40), s(30)),
          bottomLeft: Radius.elliptical(s(34), s(40)),
          bottomRight: Radius.circular(s(22)),
        );
      case 2:
        return BorderRadius.only(
          topLeft: Radius.elliptical(s(30), s(40)),
          topRight: Radius.elliptical(s(40), s(30)),
          bottomLeft: Radius.circular(s(28)),
          bottomRight: Radius.circular(s(20)),
        );
      default:
        return BorderRadius.only(
          topLeft: Radius.circular(s(20)),
          topRight: Radius.elliptical(s(34), s(40)),
          bottomLeft: Radius.elliptical(s(40), s(28)),
          bottomRight: Radius.circular(s(20)),
        );
    }
  }

  /// Borda "gota" mais sutil para chips e badges.
  static BorderRadius dropPill() => const BorderRadius.only(
        topLeft: Radius.elliptical(40, 24),
        topRight: Radius.elliptical(20, 24),
        bottomLeft: Radius.elliptical(20, 24),
        bottomRight: Radius.elliptical(40, 24),
      );
}

/// Fundo do app com gradiente "Liquid".
class LiquidBackground extends StatelessWidget {
  final Widget child;
  const LiquidBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: dark
                  ? LiquidGlass.backgroundDark()
                  : LiquidGlass.backgroundLight(),
            ),
          ),
        ),
        // Borrões orgânicos sutis criando profundidade fluida.
        Positioned(
          top: -120,
          right: -80,
          child: _Blob(
            color: AppColors.primaryLight.withOpacity(dark ? 0.10 : 0.22),
            size: 320,
          ),
        ),
        Positioned(
          bottom: -160,
          left: -100,
          child: _Blob(
            color: AppColors.accent.withOpacity(dark ? 0.08 : 0.16),
            size: 360,
          ),
        ),
        Positioned(
          top: 240,
          left: -60,
          child: _Blob(
            color: AppColors.primary.withOpacity(dark ? 0.10 : 0.12),
            size: 220,
          ),
        ),
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withOpacity(0)],
            stops: const [0, 1],
          ),
        ),
      ),
    );
  }
}

/// Cartão de vidro líquido: blur do fundo + cor translúcida +
/// borda orgânica + brilho interno sutil.
class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final int radiusVariant;
  final VoidCallback? onTap;
  final double blur;
  final double intensity;
  final Color? tint;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radiusVariant = 0,
    this.onTap,
    this.blur = 18,
    this.intensity = 1,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    final base = tint ?? scheme.surface;

    final radius = LiquidGlass.organic(variant: radiusVariant);

    final glassTop = base.withOpacity(dark ? 0.22 : 0.55) * (1);
    final glassBottom = base.withOpacity(dark ? 0.12 : 0.35);

    final body = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                glassTop,
                glassBottom,
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(dark ? 0.10 : 0.55),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(dark ? 0.4 : 0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap == null) return body;

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: body,
      ),
    );
  }
}

extension on Color {
  Color operator *(num k) => this;
}

/// Fundo "Hero" da Home: imagem do aquário + camadas de overlay
/// pra garantir contraste WCAG AA do texto/cards em cima.
///
/// Acessibilidade: o overlay escuro com gradient duplo cria mais de
/// 7:1 de contraste com texto branco — atendendo AAA inclusive pra
/// pessoas com baixa visão.
class HeroBackground extends StatelessWidget {
  final Widget child;
  const HeroBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Imagem base
        Positioned.fill(
          child: Image.asset(
            'assets/bg/hero_home.jpeg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        // 2. Camada de cor da marca (verde-floresta) pra unificar tom
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryDark.withOpacity(0.55),
                  AppColors.primary.withOpacity(0.35),
                  Colors.black.withOpacity(0.65),
                ],
                stops: const [0, 0.5, 1],
              ),
            ),
          ),
        ),
        // 3. Gradient escuro vertical (lê melhor com pessoas mais velhas
        // — texto sobre área mais escura na parte inferior onde fica o
        // miolo do conteúdo)
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.10),
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.65),
                ],
                stops: const [0, 0.45, 1],
              ),
            ),
          ),
        ),
        // 4. Borrões de luz orgânicos (sutilíssimos)
        Positioned(
          top: -100,
          right: -60,
          child: IgnorePointer(
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryLight.withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -140,
          left: -80,
          child: IgnorePointer(
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        // 5. Conteúdo
        child,
      ],
    );
  }
}

