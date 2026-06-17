import 'package:flutter/material.dart';

import '../models/especie.dart';

class ClasseIconData {
  final String asset;
  final Color color;
  const ClasseIconData(this.asset, this.color);

  static ClasseIconData of(ClasseTaxonomica c) {
    switch (c) {
      case ClasseTaxonomica.mamifero:
        return const ClasseIconData(
            'assets/classes/mamifero.png', Color(0xFFB07B45));
      case ClasseTaxonomica.reptil:
        return const ClasseIconData(
            'assets/classes/reptil.png', Color(0xFF6F9E3D));
      case ClasseTaxonomica.anfibio:
        return const ClasseIconData(
            'assets/classes/anfibio.png', Color(0xFF3B9B7E));
      case ClasseTaxonomica.peixe:
        return const ClasseIconData(
            'assets/classes/peixe.png', Color(0xFF2A86C9));
      case ClasseTaxonomica.ave:
        return const ClasseIconData(
            'assets/classes/ave.png', Color(0xFFD96B3F));
      case ClasseTaxonomica.invertebrado:
        return const ClasseIconData(
            'assets/classes/invertebrado.png', Color(0xFF8E4FBF));
    }
  }
}

/// Ícone PNG da classe taxonômica (com cor original do desenho).
class ClasseIcon extends StatelessWidget {
  final ClasseTaxonomica classe;
  final double size;
  final Color? color;

  const ClasseIcon({
    super.key,
    required this.classe,
    this.size = 22,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final data = ClasseIconData.of(classe);
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        data.asset,
        fit: BoxFit.contain,
        // Se um color customizado for passado (ex: branco em fundo escuro),
        // pinta o ícone com srcIn pra ficar monocromático.
        color: color,
        colorBlendMode: color != null ? BlendMode.srcIn : null,
      ),
    );
  }
}

/// Avatar circular com a cor da classe + ícone PNG branco em cima.
class ClasseAvatar extends StatelessWidget {
  final ClasseTaxonomica classe;
  final double size;

  /// `soft = true` → fundo translúcido na cor da classe + ícone colorido.
  /// `soft = false` (padrão) → fundo sólido na cor da classe + ícone branco.
  final bool soft;

  const ClasseAvatar({
    super.key,
    required this.classe,
    this.size = 32,
    this.soft = false,
  });

  @override
  Widget build(BuildContext context) {
    final data = ClasseIconData.of(classe);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: soft ? data.color.withOpacity(0.15) : data.color,
        shape: BoxShape.circle,
        border: soft
            ? null
            : Border.all(color: Colors.white.withOpacity(0.25), width: 1),
      ),
      padding: EdgeInsets.all(size * 0.18),
      child: Image.asset(
        data.asset,
        fit: BoxFit.contain,
        color: soft ? null : Colors.white,
        colorBlendMode: soft ? null : BlendMode.srcIn,
      ),
    );
  }
}
