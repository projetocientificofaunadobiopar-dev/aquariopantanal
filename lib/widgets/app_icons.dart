import 'package:flutter/widgets.dart';

/// IconData puro apontando para as fontes do pacote font_awesome_flutter
/// (Solid e Regular). Evita estender IconData (final no Flutter 3.44+).
class AppIcons {
  AppIcons._();

  static const _solid = 'FontAwesomeSolid';
  static const _regular = 'FontAwesomeRegular';
  static const _pkg = 'font_awesome_flutter';

  // ===== Classes taxonômicas =====
  static const IconData paw =
      IconData(0xf1b0, fontFamily: _solid, fontPackage: _pkg);
  static const IconData staffSnake =
      IconData(0xe579, fontFamily: _solid, fontPackage: _pkg);
  static const IconData frog =
      IconData(0xf52e, fontFamily: _solid, fontPackage: _pkg);
  static const IconData fish =
      IconData(0xf578, fontFamily: _solid, fontPackage: _pkg);
  static const IconData dove =
      IconData(0xf4ba, fontFamily: _solid, fontPackage: _pkg);
  static const IconData spider =
      IconData(0xf717, fontFamily: _solid, fontPackage: _pkg);

  // ===== Menu =====
  static const IconData house =
      IconData(0xf015, fontFamily: _regular, fontPackage: _pkg);
  static const IconData circleInfo =
      IconData(0xf05a, fontFamily: _solid, fontPackage: _pkg);
  static const IconData sliders =
      IconData(0xf1de, fontFamily: _solid, fontPackage: _pkg);
  static const IconData rightToBracket =
      IconData(0xf2f6, fontFamily: _solid, fontPackage: _pkg);

  // ===== Sobre =====
  static const IconData locationDot =
      IconData(0xf3c5, fontFamily: _solid, fontPackage: _pkg);
  static const IconData clock =
      IconData(0xf017, fontFamily: _regular, fontPackage: _pkg);
  static const IconData graduationCap =
      IconData(0xf19d, fontFamily: _solid, fontPackage: _pkg);
}
