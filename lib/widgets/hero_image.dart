import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Hero que mantém a imagem sempre cobrindo a área com `BoxFit.cover` durante
/// toda a transição entre telas. Resolve a distorção/jump quando o formato do
/// source (card retrato) é diferente do destination (header paisagem).
class HeroImage extends StatelessWidget {
  final String tag;
  final String url;
  final Widget? placeholder;
  final Widget? errorWidget;

  const HeroImage({
    super.key,
    required this.tag,
    required this.url,
    this.placeholder,
    this.errorWidget,
  });

  Widget _image() {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: placeholder == null ? null : (_, __) => placeholder!,
      errorWidget:
          errorWidget == null ? null : (_, __, ___) => errorWidget!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: (_, anim, dir, fromCtx, toCtx) {
        // Durante o voo, renderiza a imagem sempre com BoxFit.cover
        // ocupando 100% do espaço alocado pelo Hero overlay, evitando a
        // distorção causada pela mudança de aspect ratio.
        return Material(
          color: Colors.transparent,
          child: _image(),
        );
      },
      child: _image(),
    );
  }
}
