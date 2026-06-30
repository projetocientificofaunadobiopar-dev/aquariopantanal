import 'dart:math' as math;

import '../providers/locale_provider.dart';

enum ClasseTaxonomica {
  mamifero('mamifero', '🦝', 'Mamífero', 'Mammal', 'Mamífero'),
  reptil('reptil', '🦎', 'Réptil', 'Reptile', 'Reptil'),
  anfibio('anfibio', '🐸', 'Anfíbio', 'Amphibian', 'Anfibio'),
  peixe('peixe', '🐟', 'Peixe', 'Fish', 'Pez'),
  ave('ave', '🦜', 'Ave', 'Bird', 'Ave'),
  invertebrado(
      'invertebrado', '🦋', 'Invertebrado', 'Invertebrate', 'Invertebrado');

  final String codigo;
  final String emoji;
  final String nomePt;
  final String nomeEn;
  final String nomeEs;
  const ClasseTaxonomica(
      this.codigo, this.emoji, this.nomePt, this.nomeEn, this.nomeEs);

  String label(AppLocale loc) {
    switch (loc) {
      case AppLocale.pt:
        return nomePt;
      case AppLocale.en:
        return nomeEn;
      case AppLocale.es:
        return nomeEs;
    }
  }

  static ClasseTaxonomica? fromCodigo(String? c) {
    if (c == null) return null;
    for (final v in values) {
      if (v.codigo == c) return v;
    }
    return null;
  }
}

enum StatusConservacao {
  lc('LC', 0xFF4CAF50, 'Pouco preocupante', 'Least Concern',
      'Preocupación menor'),
  nt('NT', 0xFF8BC34A, 'Quase ameaçada', 'Near Threatened', 'Casi amenazada'),
  vu('VU', 0xFFFFC107, 'Vulnerável', 'Vulnerable', 'Vulnerable'),
  en('EN', 0xFFFF9800, 'Em perigo', 'Endangered', 'En peligro'),
  cr('CR', 0xFFF44336, 'Criticamente em perigo', 'Critically Endangered',
      'En peligro crítico'),
  ew('EW', 0xFF9C27B0, 'Extinta na natureza', 'Extinct in the Wild',
      'Extinta en la naturaleza'),
  ex('EX', 0xFF424242, 'Extinta', 'Extinct', 'Extinta'),
  dd('DD', 0xFF9E9E9E, 'Dados insuficientes', 'Data Deficient',
      'Datos insuficientes');

  final String codigo;
  final int cor;
  final String nomePt;
  final String nomeEn;
  final String nomeEs;
  const StatusConservacao(
      this.codigo, this.cor, this.nomePt, this.nomeEn, this.nomeEs);

  String label(AppLocale loc) {
    switch (loc) {
      case AppLocale.pt:
        return nomePt;
      case AppLocale.en:
        return nomeEn;
      case AppLocale.es:
        return nomeEs;
    }
  }

  static StatusConservacao? fromCodigo(String? c) {
    if (c == null) return null;
    for (final v in values) {
      if (v.codigo == c) return v;
    }
    return null;
  }

  /// 0xFFFFFFFF (branco) ou 0xFF111111 (quase preto) — o que tiver melhor
  /// contraste sobre [cor]. Usa luminância relativa do WCAG.
  int get corTexto {
    double lin(double c) =>
        c <= 0.03928 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
    final r = lin(((cor >> 16) & 0xFF) / 255.0);
    final g = lin(((cor >> 8) & 0xFF) / 255.0);
    final b = lin((cor & 0xFF) / 255.0);
    final l = 0.2126 * r + 0.7152 * g + 0.0722 * b;
    return l > 0.18 ? 0xFF111111 : 0xFFFFFFFF;
  }
}

class Especie {
  final String id;
  final String? slug;

  final String nomePopularPt;
  final String nomePopularEn;
  final String? nomePopularEs;

  final String nomeCientifico;

  final String biomaOrigemPt;
  final String biomaOrigemEn;
  final String? biomaOrigemEs;

  final String nichoEcologicoPt;
  final String nichoEcologicoEn;
  final String? nichoEcologicoEs;

  final String? imagemUrl;
  final List<String> imagens;
  final String? statusConservacao;
  final String? classe;
  final String? familia;

  final String? setor;
  final String? tanque;
  final bool publicado;

  final String? tamanhoPt;
  final String? tamanhoEn;
  final String? tamanhoEs;

  final String? dietaPt;
  final String? dietaEn;
  final String? dietaEs;

  final String? curiosidadePt;
  final String? curiosidadeEn;
  final String? curiosidadeEs;

  final String? expectativaVidaPt;
  final String? expectativaVidaEn;
  final String? expectativaVidaEs;

  final String? ameacasPt;
  final String? ameacasEn;
  final String? ameacasEs;

  Especie({
    required this.id,
    this.slug,
    required this.nomePopularPt,
    required this.nomePopularEn,
    this.nomePopularEs,
    required this.nomeCientifico,
    required this.biomaOrigemPt,
    required this.biomaOrigemEn,
    this.biomaOrigemEs,
    required this.nichoEcologicoPt,
    required this.nichoEcologicoEn,
    this.nichoEcologicoEs,
    this.imagemUrl,
    this.imagens = const [],
    this.statusConservacao,
    this.classe,
    this.familia,
    this.setor,
    this.tanque,
    this.publicado = true,
    this.tamanhoPt,
    this.tamanhoEn,
    this.tamanhoEs,
    this.dietaPt,
    this.dietaEn,
    this.dietaEs,
    this.curiosidadePt,
    this.curiosidadeEn,
    this.curiosidadeEs,
    this.expectativaVidaPt,
    this.expectativaVidaEn,
    this.expectativaVidaEs,
    this.ameacasPt,
    this.ameacasEn,
    this.ameacasEs,
  });

  factory Especie.fromMap(Map<String, dynamic> m) => Especie(
        id: m['id'] as String,
        slug: m['slug'] as String?,
        nomePopularPt: (m['nome_popular_pt'] ?? '') as String,
        nomePopularEn: (m['nome_popular_en'] ?? '') as String,
        nomePopularEs: m['nome_popular_es'] as String?,
        nomeCientifico: (m['nome_cientifico'] ?? '') as String,
        biomaOrigemPt: (m['bioma_origem_pt'] ?? '') as String,
        biomaOrigemEn: (m['bioma_origem_en'] ?? '') as String,
        biomaOrigemEs: m['bioma_origem_es'] as String?,
        nichoEcologicoPt: (m['nicho_ecologico_pt'] ?? '') as String,
        nichoEcologicoEn: (m['nicho_ecologico_en'] ?? '') as String,
        nichoEcologicoEs: m['nicho_ecologico_es'] as String?,
        imagemUrl: m['imagem_url'] as String?,
        imagens: (m['imagens'] as List?)
                ?.map((e) => e.toString())
                .where((s) => s.isNotEmpty)
                .toList() ??
            const [],
        statusConservacao: m['status_conservacao'] as String?,
        classe: m['classe'] as String?,
        familia: m['familia'] as String?,
        setor: m['setor'] as String?,
        tanque: m['tanque'] as String?,
        publicado: (m['publicado'] as bool?) ?? true,
        tamanhoPt: m['tamanho_pt'] as String?,
        tamanhoEn: m['tamanho_en'] as String?,
        tamanhoEs: m['tamanho_es'] as String?,
        dietaPt: m['dieta_pt'] as String?,
        dietaEn: m['dieta_en'] as String?,
        dietaEs: m['dieta_es'] as String?,
        curiosidadePt: m['curiosidade_pt'] as String?,
        curiosidadeEn: m['curiosidade_en'] as String?,
        curiosidadeEs: m['curiosidade_es'] as String?,
        expectativaVidaPt: m['expectativa_vida_pt'] as String?,
        expectativaVidaEn: m['expectativa_vida_en'] as String?,
        expectativaVidaEs: m['expectativa_vida_es'] as String?,
        ameacasPt: m['ameacas_pt'] as String?,
        ameacasEn: m['ameacas_en'] as String?,
        ameacasEs: m['ameacas_es'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'nome_popular_pt': nomePopularPt,
        'nome_popular_en': nomePopularEn,
        'nome_popular_es': nomePopularEs,
        'nome_cientifico': nomeCientifico,
        'bioma_origem_pt': biomaOrigemPt,
        'bioma_origem_en': biomaOrigemEn,
        'bioma_origem_es': biomaOrigemEs,
        'nicho_ecologico_pt': nichoEcologicoPt,
        'nicho_ecologico_en': nichoEcologicoEn,
        'nicho_ecologico_es': nichoEcologicoEs,
        'imagem_url': imagemUrl,
        'imagens': imagens,
        'status_conservacao': statusConservacao,
        'classe': classe,
        'familia': familia,
        'setor': setor,
        'tanque': tanque,
        'publicado': publicado,
        'tamanho_pt': tamanhoPt,
        'tamanho_en': tamanhoEn,
        'tamanho_es': tamanhoEs,
        'dieta_pt': dietaPt,
        'dieta_en': dietaEn,
        'dieta_es': dietaEs,
        'curiosidade_pt': curiosidadePt,
        'curiosidade_en': curiosidadeEn,
        'curiosidade_es': curiosidadeEs,
        'expectativa_vida_pt': expectativaVidaPt,
        'expectativa_vida_en': expectativaVidaEn,
        'expectativa_vida_es': expectativaVidaEs,
        'ameacas_pt': ameacasPt,
        'ameacas_en': ameacasEn,
        'ameacas_es': ameacasEs,
      };

  // ===== Helpers localizados com fallback para PT =====
  String _pick(AppLocale loc, String pt, String? en, String? es) {
    switch (loc) {
      case AppLocale.pt:
        return pt;
      case AppLocale.en:
        return (en != null && en.trim().isNotEmpty) ? en : pt;
      case AppLocale.es:
        return (es != null && es.trim().isNotEmpty) ? es : pt;
    }
  }

  String? _pickOpt(AppLocale loc, String? pt, String? en, String? es) {
    if (pt == null && en == null && es == null) return null;
    if (pt == null || pt.trim().isEmpty) return null;
    return _pick(loc, pt, en, es);
  }

  bool _fallback(AppLocale loc, String? en, String? es) {
    if (loc == AppLocale.pt) return false;
    if (loc == AppLocale.en) return en == null || en.trim().isEmpty;
    return es == null || es.trim().isEmpty;
  }

  String nomePopular(AppLocale loc) =>
      _pick(loc, nomePopularPt, nomePopularEn, nomePopularEs);
  String bioma(AppLocale loc) =>
      _pick(loc, biomaOrigemPt, biomaOrigemEn, biomaOrigemEs);
  String nicho(AppLocale loc) =>
      _pick(loc, nichoEcologicoPt, nichoEcologicoEn, nichoEcologicoEs);
  String? tamanho(AppLocale loc) =>
      _pickOpt(loc, tamanhoPt, tamanhoEn, tamanhoEs);
  String? dieta(AppLocale loc) =>
      _pickOpt(loc, dietaPt, dietaEn, dietaEs);
  String? curiosidade(AppLocale loc) =>
      _pickOpt(loc, curiosidadePt, curiosidadeEn, curiosidadeEs);
  String? expectativaVida(AppLocale loc) =>
      _pickOpt(loc, expectativaVidaPt, expectativaVidaEn, expectativaVidaEs);
  String? ameacas(AppLocale loc) =>
      _pickOpt(loc, ameacasPt, ameacasEn, ameacasEs);

  /// Retorna true se ALGUM dos campos principais caiu no fallback PT.
  bool houveFallback(AppLocale loc) {
    if (loc == AppLocale.pt) return false;
    return _fallback(loc, nomePopularEn, nomePopularEs) ||
        _fallback(loc, biomaOrigemEn, biomaOrigemEs) ||
        _fallback(loc, nichoEcologicoEn, nichoEcologicoEs);
  }

  ClasseTaxonomica? get classeEnum => ClasseTaxonomica.fromCodigo(classe);
  StatusConservacao? get statusEnum =>
      StatusConservacao.fromCodigo(statusConservacao);

  /// Texto curto pra localização (ex.: "Setor B · Aquário 3").
  /// Retorna null se nada estiver preenchido.
  String? localizacao(AppLocale loc) {
    final s = (setor ?? '').trim();
    final t = (tanque ?? '').trim();
    if (s.isEmpty && t.isEmpty) return null;
    final partes = <String>[];
    if (s.isNotEmpty) {
      partes.add(loc == AppLocale.en
          ? 'Sector $s'
          : loc == AppLocale.es
              ? 'Sector $s'
              : 'Setor $s');
    }
    if (t.isNotEmpty) {
      partes.add(loc == AppLocale.en
          ? 'Tank $t'
          : loc == AppLocale.es
              ? 'Acuario $t'
              : 'Aquário $t');
    }
    return partes.join(' · ');
  }

  /// Lista completa de fotos (capa primeiro, depois adicionais), sem nulos/vazios.
  List<String> get galeria {
    final out = <String>[];
    if (imagemUrl != null && imagemUrl!.trim().isNotEmpty) out.add(imagemUrl!);
    for (final u in imagens) {
      if (u.trim().isNotEmpty) out.add(u);
    }
    return out;
  }

  // ===== Completude por idioma (admin) =====
  bool get temImagem => imagemUrl != null && imagemUrl!.isNotEmpty;

  bool get completoEn =>
      nomePopularEn.trim().isNotEmpty &&
      biomaOrigemEn.trim().isNotEmpty &&
      nichoEcologicoEn.trim().isNotEmpty;

  bool get completoEs =>
      (nomePopularEs ?? '').trim().isNotEmpty &&
      (biomaOrigemEs ?? '').trim().isNotEmpty &&
      (nichoEcologicoEs ?? '').trim().isNotEmpty;
}
