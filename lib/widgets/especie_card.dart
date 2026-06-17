import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/especie.dart';
import '../providers/locale_provider.dart';
import 'classe_icon.dart';
import 'hero_image.dart';

class EspecieCard extends StatefulWidget {
  final Especie especie;
  final AppLocale loc;
  final VoidCallback onTap;

  const EspecieCard({
    super.key,
    required this.especie,
    required this.loc,
    required this.onTap,
  });

  @override
  State<EspecieCard> createState() => _EspecieCardState();
}

class _EspecieCardState extends State<EspecieCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final status = widget.especie.statusEnum;
    final classe = widget.especie.classeEnum;
    final scheme = Theme.of(context).colorScheme;
    final fb = widget.especie.houveFallback(widget.loc);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.02 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Material(
          elevation: _hover ? 12 : 2,
          shadowColor: Colors.black.withOpacity(0.18),
          borderRadius: BorderRadius.circular(22),
          clipBehavior: Clip.antiAlias,
          color: scheme.surface,
          child: InkWell(
            onTap: widget.onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                widget.especie.imagemUrl == null
                    ? Container(
                        color: scheme.surfaceContainerHighest,
                        child: Icon(Icons.pets,
                            size: 64,
                            color: scheme.onSurface.withOpacity(0.3)),
                      )
                    : HeroImage(
                        tag: 'img_${widget.especie.id}',
                        url: widget.especie.imagemUrl!,
                        placeholder: Shimmer.fromColors(
                          baseColor: scheme.surfaceContainerHighest,
                          highlightColor: scheme.surface,
                          child: Container(
                              color: scheme.surfaceContainerHighest),
                        ),
                        errorWidget: Container(
                          color: scheme.surfaceContainerHighest,
                          child: const Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.35),
                          Colors.black.withOpacity(0.85),
                        ],
                        stops: const [0, 0.45, 0.78, 1],
                      ),
                    ),
                  ),
                ),
                if (status != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _pill(
                      Color(status.cor),
                      Text(
                        status.codigo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                if (classe != null)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: ClasseAvatar(classe: classe, size: 32),
                  ),
                if (fb)
                  Positioned(
                    bottom: 56,
                    left: 12,
                    child: _pill(
                      Colors.black.withOpacity(0.55),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.translate_rounded,
                              color: Colors.white, size: 11),
                          SizedBox(width: 4),
                          Text('PT',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              )),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.especie.nomePopular(widget.loc),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          shadows: [
                            Shadow(blurRadius: 4, color: Colors.black54),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.especie.nomeCientifico,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pill(Color bg, Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: bg.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
