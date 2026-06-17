import 'package:flutter/material.dart';

import '../models/especie.dart';
import 'app_icons.dart';

class ClasseIconData {
  final IconData icon;
  final Color color;
  const ClasseIconData(this.icon, this.color);

  static ClasseIconData of(ClasseTaxonomica c) {
    switch (c) {
      case ClasseTaxonomica.mamifero:
        return const ClasseIconData(AppIcons.paw, Color(0xFFB07B45));
      case ClasseTaxonomica.reptil:
        return const ClasseIconData(AppIcons.staffSnake, Color(0xFF6F9E3D));
      case ClasseTaxonomica.anfibio:
        return const ClasseIconData(AppIcons.frog, Color(0xFF3B9B7E));
      case ClasseTaxonomica.peixe:
        return const ClasseIconData(AppIcons.fish, Color(0xFF2A86C9));
      case ClasseTaxonomica.ave:
        return const ClasseIconData(AppIcons.dove, Color(0xFFD96B3F));
      case ClasseTaxonomica.invertebrado:
        return const ClasseIconData(AppIcons.spider, Color(0xFF8E4FBF));
    }
  }
}

class ClasseIcon extends StatelessWidget {
  final ClasseTaxonomica classe;
  final double size;
  final Color? color;
  const ClasseIcon({
    super.key,
    required this.classe,
    this.size = 18,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final data = ClasseIconData.of(classe);
    return Icon(data.icon, size: size, color: color ?? data.color);
  }
}

class ClasseAvatar extends StatelessWidget {
  final ClasseTaxonomica classe;
  final double size;
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
            : Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Icon(
        data.icon,
        size: size * 0.5,
        color: soft ? data.color : Colors.white,
      ),
    );
  }
}
