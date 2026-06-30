import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../i18n/strings.dart';
import '../../models/especie.dart';
import '../../providers/locale_provider.dart';
import '../../services/image_compressor.dart';
import '../../services/supabase_service.dart';
import '../../widgets/classe_icon.dart';
import '../../widgets/photo_cropper.dart';

class EspecieForm extends StatefulWidget {
  final Especie? editar;
  const EspecieForm({super.key, this.editar});

  @override
  State<EspecieForm> createState() => _EspecieFormState();
}

class _EspecieFormState extends State<EspecieForm>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  final _svc = SupabaseService();
  late final TabController _tab;

  // Comuns
  late final TextEditingController _cientifico;
  late final TextEditingController _familia;
  late final TextEditingController _setor;
  late final TextEditingController _tanque;
  bool _publicado = true;

  // PT
  late final TextEditingController _nomePt;
  late final TextEditingController _biomaPt;
  late final TextEditingController _nichoPt;
  late final TextEditingController _tamPt;
  late final TextEditingController _dietaPt;
  late final TextEditingController _vidaPt;
  late final TextEditingController _ameacasPt;
  late final TextEditingController _curiPt;

  // EN
  late final TextEditingController _nomeEn;
  late final TextEditingController _biomaEn;
  late final TextEditingController _nichoEn;
  late final TextEditingController _tamEn;
  late final TextEditingController _dietaEn;
  late final TextEditingController _vidaEn;
  late final TextEditingController _ameacasEn;
  late final TextEditingController _curiEn;

  // ES
  late final TextEditingController _nomeEs;
  late final TextEditingController _biomaEs;
  late final TextEditingController _nichoEs;
  late final TextEditingController _tamEs;
  late final TextEditingController _dietaEs;
  late final TextEditingController _vidaEs;
  late final TextEditingController _ameacasEs;
  late final TextEditingController _curiEs;

  StatusConservacao? _status;
  ClasseTaxonomica? _classe;

  String? _imagemUrl;
  Uint8List? _novoBytes;
  String? _novoNome;

  // Galeria: fotos adicionais além da capa.
  late List<String> _galeriaExistente;
  final List<_FotoPendente> _galeriaNovas = [];

  bool _saving = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    final e = widget.editar;

    _cientifico = TextEditingController(text: e?.nomeCientifico ?? '');
    _familia = TextEditingController(text: e?.familia ?? '');
    _setor = TextEditingController(text: e?.setor ?? '');
    _tanque = TextEditingController(text: e?.tanque ?? '');
    _publicado = e?.publicado ?? true;

    _nomePt = TextEditingController(text: e?.nomePopularPt ?? '');
    _biomaPt = TextEditingController(text: e?.biomaOrigemPt ?? '');
    _nichoPt = TextEditingController(text: e?.nichoEcologicoPt ?? '');
    _tamPt = TextEditingController(text: e?.tamanhoPt ?? '');
    _dietaPt = TextEditingController(text: e?.dietaPt ?? '');
    _vidaPt = TextEditingController(text: e?.expectativaVidaPt ?? '');
    _ameacasPt = TextEditingController(text: e?.ameacasPt ?? '');
    _curiPt = TextEditingController(text: e?.curiosidadePt ?? '');

    _nomeEn = TextEditingController(text: e?.nomePopularEn ?? '');
    _biomaEn = TextEditingController(text: e?.biomaOrigemEn ?? '');
    _nichoEn = TextEditingController(text: e?.nichoEcologicoEn ?? '');
    _tamEn = TextEditingController(text: e?.tamanhoEn ?? '');
    _dietaEn = TextEditingController(text: e?.dietaEn ?? '');
    _vidaEn = TextEditingController(text: e?.expectativaVidaEn ?? '');
    _ameacasEn = TextEditingController(text: e?.ameacasEn ?? '');
    _curiEn = TextEditingController(text: e?.curiosidadeEn ?? '');

    _nomeEs = TextEditingController(text: e?.nomePopularEs ?? '');
    _biomaEs = TextEditingController(text: e?.biomaOrigemEs ?? '');
    _nichoEs = TextEditingController(text: e?.nichoEcologicoEs ?? '');
    _tamEs = TextEditingController(text: e?.tamanhoEs ?? '');
    _dietaEs = TextEditingController(text: e?.dietaEs ?? '');
    _vidaEs = TextEditingController(text: e?.expectativaVidaEs ?? '');
    _ameacasEs = TextEditingController(text: e?.ameacasEs ?? '');
    _curiEs = TextEditingController(text: e?.curiosidadeEs ?? '');

    _status = e?.statusEnum;
    _classe = e?.classeEnum;
    _imagemUrl = e?.imagemUrl;
    _galeriaExistente = List<String>.from(e?.imagens ?? const []);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _escolherImagem() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(
      source: ImageSource.gallery,
      // Resolução generosa pra dar margem de crop sem perder qualidade.
      maxWidth: 2048,
      imageQuality: 92,
    );
    if (x == null) return;
    final bytes = await x.readAsBytes();
    if (!mounted) return;

    // Abre o cropper 3:4 e aguarda os bytes ajustados.
    final cropped = await PhotoCropperPage.abrir(context, bytes);
    if (cropped == null) return; // usuário cancelou

    setState(() {
      _novoBytes = cropped;
      // Garante extensão png já que o cropper sempre gera PNG.
      final base = x.name.replaceAll(RegExp(r'\.[^.]+$'), '');
      _novoNome = '$base.png';
    });
  }

  Future<void> _adicionarFotoGaleria() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      imageQuality: 92,
    );
    if (x == null) return;
    final bytes = await x.readAsBytes();
    if (!mounted) return;
    final cropped = await PhotoCropperPage.abrir(context, bytes);
    if (cropped == null) return;
    final base = x.name.replaceAll(RegExp(r'\.[^.]+$'), '');
    setState(() {
      _galeriaNovas.add(_FotoPendente(bytes: cropped, name: '$base.png'));
    });
  }

  /// Upload em lote: seleciona várias fotos de uma vez sem passar pelo cropper.
  /// Bom pra adicionar muitas fotos rápido — a galeria não exige 3:4.
  Future<void> _adicionarMultiplas() async {
    final picker = ImagePicker();
    final xs = await picker.pickMultiImage(maxWidth: 2048, imageQuality: 92);
    if (xs.isEmpty || !mounted) return;
    final novas = <_FotoPendente>[];
    for (final x in xs) {
      final bytes = await x.readAsBytes();
      novas.add(_FotoPendente(bytes: bytes, name: x.name));
    }
    if (!mounted) return;
    setState(() => _galeriaNovas.addAll(novas));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${novas.length} foto(s) adicionada(s) à galeria'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _salvar(Strings s) async {
    if (!_form.currentState!.validate()) {
      _tab.animateTo(0); // PT é onde estão os obrigatórios
      return;
    }
    setState(() {
      _saving = true;
      _erro = null;
    });
    try {
      String? url = _imagemUrl;
      if (_novoBytes != null) {
        final comp = await comprimirParaUpload(
          _novoBytes!,
          _novoNome ?? 'imagem.jpg',
        );
        url = await _svc.uploadImagem(
          bytes: comp.bytes,
          filename: comp.filename,
          contentType: comp.contentType,
        );
      }
      // Upload das fotos novas da galeria (com compressão)
      final novasUrls = <String>[];
      for (final f in _galeriaNovas) {
        final comp = await comprimirParaUpload(f.bytes, f.name);
        final u = await _svc.uploadImagem(
          bytes: comp.bytes,
          filename: comp.filename,
          contentType: comp.contentType,
        );
        novasUrls.add(u);
      }
      final galeriaFinal = [..._galeriaExistente, ...novasUrls];
      String? n(TextEditingController c) =>
          c.text.trim().isEmpty ? null : c.text.trim();
      final e = Especie(
        id: widget.editar?.id ?? '',
        nomePopularPt: _nomePt.text.trim(),
        nomePopularEn: _nomeEn.text.trim(),
        nomePopularEs: n(_nomeEs),
        nomeCientifico: _cientifico.text.trim(),
        biomaOrigemPt: _biomaPt.text.trim(),
        biomaOrigemEn: _biomaEn.text.trim(),
        biomaOrigemEs: n(_biomaEs),
        nichoEcologicoPt: _nichoPt.text.trim(),
        nichoEcologicoEn: _nichoEn.text.trim(),
        nichoEcologicoEs: n(_nichoEs),
        imagemUrl: url,
        imagens: galeriaFinal,
        statusConservacao: _status?.codigo,
        classe: _classe?.codigo,
        familia: n(_familia),
        setor: n(_setor),
        tanque: n(_tanque),
        publicado: _publicado,
        tamanhoPt: n(_tamPt),
        tamanhoEn: n(_tamEn),
        tamanhoEs: n(_tamEs),
        dietaPt: n(_dietaPt),
        dietaEn: n(_dietaEn),
        dietaEs: n(_dietaEs),
        curiosidadePt: n(_curiPt),
        curiosidadeEn: n(_curiEn),
        curiosidadeEs: n(_curiEs),
        expectativaVidaPt: n(_vidaPt),
        expectativaVidaEn: n(_vidaEn),
        expectativaVidaEs: n(_vidaEs),
        ameacasPt: n(_ameacasPt),
        ameacasEn: n(_ameacasEn),
        ameacasEs: n(_ameacasEs),
      );
      if (widget.editar == null) {
        await _svc.inserir(e);
      } else {
        await _svc.atualizar(widget.editar!.id, e);
      }
      if (mounted) context.pop(true);
    } catch (err) {
      setState(() => _erro = err.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _req(String? v, Strings s) =>
      (v == null || v.trim().isEmpty) ? s.campoObrigatorio : null;

  bool _ptOk() =>
      _nomePt.text.trim().isNotEmpty &&
      _biomaPt.text.trim().isNotEmpty &&
      _nichoPt.text.trim().isNotEmpty;
  bool _enOk() =>
      _nomeEn.text.trim().isNotEmpty &&
      _biomaEn.text.trim().isNotEmpty &&
      _nichoEn.text.trim().isNotEmpty;
  bool _esOk() =>
      _nomeEs.text.trim().isNotEmpty &&
      _biomaEs.text.trim().isNotEmpty &&
      _nichoEs.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final s = Strings(context.watch<LocaleProvider>().locale);
    final loc = context.watch<LocaleProvider>().locale;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        title: Text(widget.editar == null ? s.novo : s.editar),
        bottom: TabBar(
          controller: _tab,
          labelColor: scheme.primary,
          unselectedLabelColor: scheme.onSurface.withOpacity(0.55),
          indicatorColor: scheme.primary,
          indicatorWeight: 3,
          tabs: [
            _tabLabel('Português', _ptOk()),
            _tabLabel('English', _enOk()),
            _tabLabel('Español', _esOk()),
          ],
        ),
      ),
      body: Form(
        key: _form,
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _abaIdioma(
                    s: s,
                    obrigatorio: true,
                    nome: _nomePt,
                    bioma: _biomaPt,
                    nicho: _nichoPt,
                    tam: _tamPt,
                    dieta: _dietaPt,
                    vida: _vidaPt,
                    ameacas: _ameacasPt,
                    curi: _curiPt,
                    extras: _abaPtExtras(s, loc),
                  ),
                  _abaIdioma(
                    s: s,
                    obrigatorio: false,
                    nome: _nomeEn,
                    bioma: _biomaEn,
                    nicho: _nichoEn,
                    tam: _tamEn,
                    dieta: _dietaEn,
                    vida: _vidaEn,
                    ameacas: _ameacasEn,
                    curi: _curiEn,
                  ),
                  _abaIdioma(
                    s: s,
                    obrigatorio: false,
                    nome: _nomeEs,
                    bioma: _biomaEs,
                    nicho: _nichoEs,
                    tam: _tamEs,
                    dieta: _dietaEs,
                    vida: _vidaEs,
                    ameacas: _ameacasEs,
                    curi: _curiEs,
                  ),
                ],
              ),
            ),
            _bottomBar(s),
          ],
        ),
      ),
    );
  }

  Widget _tabLabel(String label, bool ok) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          const SizedBox(width: 6),
          Icon(
            ok ? Icons.check_circle_rounded : Icons.circle_outlined,
            size: 14,
            color: ok ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _abaIdioma({
    required Strings s,
    required bool obrigatorio,
    required TextEditingController nome,
    required TextEditingController bioma,
    required TextEditingController nicho,
    required TextEditingController tam,
    required TextEditingController dieta,
    required TextEditingController vida,
    required TextEditingController ameacas,
    required TextEditingController curi,
    Widget? extras,
  }) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        if (extras != null) ...[
          extras,
          const SizedBox(height: 24),
        ],
        _secao(s.nomePopular),
        _campo(nome, s.nomePopular,
            req: obrigatorio, s: s),
        _secao(s.bioma),
        _campo(bioma, s.bioma, req: obrigatorio, s: s),
        _secao(s.nicho),
        _campo(nicho, s.nicho, req: obrigatorio, s: s, linhas: 4),
        _secao('${s.tamanho} ${s.opcional}'),
        _campo(tam, s.tamanho, s: s),
        _secao('${s.dieta} ${s.opcional}'),
        _campo(dieta, s.dieta, s: s),
        _secao('${s.expectativaVida} ${s.opcional}'),
        _campo(vida, s.expectativaVida, s: s),
        _secao('${s.ameacas} ${s.opcional}'),
        _campo(ameacas, s.ameacas, s: s, linhas: 3),
        _secao('${s.curiosidade} ${s.opcional}'),
        _campo(curi, s.curiosidade, s: s, linhas: 3),
      ],
    );
  }

  Widget _abaPtExtras(Strings s, AppLocale loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _togglePublicado(),
        const SizedBox(height: 16),
        _secao(s.nomeCientifico),
        _campo(_cientifico, s.nomeCientifico, req: true, s: s),
        _secao('${s.familia} ${s.opcional}'),
        _campo(_familia, s.familia, s: s),
        Row(
          children: [
            Expanded(child: _dropdownClasse(s, loc)),
            const SizedBox(width: 12),
            Expanded(child: _dropdownStatus(s, loc)),
          ],
        ),
        const SizedBox(height: 16),
        _secao('Localização no Bioparque (opcional)'),
        Row(
          children: [
            Expanded(
              child: _campo(_setor, 'Setor (ex: A)', s: s),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _campo(_tanque, 'Aquário/Tanque (ex: 3)', s: s),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _secao('Imagem'),
        if (_novoBytes != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                Image.memory(_novoBytes!, height: 160, fit: BoxFit.cover),
          )
        else if (_imagemUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                Image.network(_imagemUrl!, height: 160, fit: BoxFit.cover),
          ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _escolherImagem,
          icon: const Icon(Icons.image_outlined),
          label: Text(s.selecionarImagem),
        ),
        const SizedBox(height: 24),
        _secao('Galeria (fotos adicionais)'),
        _galeriaThumbs(),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _adicionarFotoGaleria,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('Adicionar foto'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _adicionarMultiplas,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Várias de uma vez'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _galeriaThumbs() {
    final scheme = Theme.of(context).colorScheme;
    final total = _galeriaExistente.length + _galeriaNovas.length;
    if (total == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: scheme.onSurface.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Icon(Icons.photo_library_outlined,
                color: scheme.onSurface.withOpacity(0.5), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Nenhuma foto adicional. A capa acima já é a 1ª da galeria.',
                style: TextStyle(
                  color: scheme.onSurface.withOpacity(0.65),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Icon(Icons.drag_indicator_rounded,
                  size: 14, color: scheme.onSurface.withOpacity(0.55)),
              const SizedBox(width: 4),
              Text(
                'Arraste pra reordenar (capa fica no topo da lista)',
                style: TextStyle(
                  fontSize: 11,
                  color: scheme.onSurface.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 106,
          child: ReorderableListView.builder(
            scrollDirection: Axis.horizontal,
            buildDefaultDragHandles: false,
            itemCount: total,
            onReorder: (oldI, newI) {
              setState(() {
                if (newI > oldI) newI -= 1;
                final lista = [..._galeriaExistente, ..._galeriaNovas];
                final item = lista.removeAt(oldI);
                lista.insert(newI, item);
                _galeriaExistente = lista
                    .whereType<String>()
                    .toList();
                _galeriaNovas
                  ..clear()
                  ..addAll(lista.whereType<_FotoPendente>());
              });
            },
            itemBuilder: (_, i) {
              final lista = [..._galeriaExistente, ..._galeriaNovas];
              final item = lista[i];
              final isNova = item is _FotoPendente;
              return ReorderableDragStartListener(
                key: ValueKey('foto_$i$item'),
                index: i,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _thumb(
                    child: isNova
                        ? Image.memory(item.bytes, fit: BoxFit.cover)
                        : Image.network(item as String, fit: BoxFit.cover),
                    badge: isNova ? 'NOVA' : null,
                    onRemove: () => setState(() {
                      if (isNova) {
                        _galeriaNovas.remove(item);
                      } else {
                        _galeriaExistente.remove(item);
                      }
                    }),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _thumb({
    required Widget child,
    String? badge,
    required VoidCallback onRemove,
  }) {
    return Stack(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Material(
            color: Colors.black.withOpacity(0.6),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onRemove,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close_rounded,
                    color: Colors.white, size: 16),
              ),
            ),
          ),
        ),
        if (badge != null)
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _bottomBar(Strings s) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_erro != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.redAccent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(_erro!,
                            style: const TextStyle(fontSize: 13))),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving ? null : () => context.pop(false),
                    child: Text(s.cancelar),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _saving ? null : () => _salvar(s),
                    child: _saving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white))
                        : Text(s.salvar),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _secao(String texto) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 6, 0, 6),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            letterSpacing: 0.5,
          ),
        ),
      );

  Widget _campo(TextEditingController c, String label,
      {bool req = false, required Strings s, int linhas = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: label,
          border: const OutlineInputBorder(),
        ),
        maxLines: linhas,
        validator: req ? (v) => _req(v, s) : null,
      ),
    );
  }

  Widget _dropdownClasse(Strings s, AppLocale loc) {
    return DropdownButtonFormField<ClasseTaxonomica?>(
      value: _classe,
      decoration: InputDecoration(
        labelText: '${s.classe} ${s.opcional}',
        border: const OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem(value: null, child: Text(s.selecione)),
        ...ClasseTaxonomica.values.map((c) => DropdownMenuItem(
              value: c,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClasseIcon(classe: c, size: 16),
                  const SizedBox(width: 8),
                  Text(c.label(loc)),
                ],
              ),
            )),
      ],
      onChanged: (v) => setState(() => _classe = v),
    );
  }

  Widget _dropdownStatus(Strings s, AppLocale loc) {
    return DropdownButtonFormField<StatusConservacao?>(
      value: _status,
      decoration: InputDecoration(
        labelText: '${s.statusConservacao} ${s.opcional}',
        border: const OutlineInputBorder(),
      ),
      isExpanded: true,
      items: [
        DropdownMenuItem(value: null, child: Text(s.selecione)),
        ...StatusConservacao.values.map((v) => DropdownMenuItem(
              value: v,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(v.cor),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      '${v.codigo}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )),
      ],
      onChanged: (v) => setState(() => _status = v),
    );
  }

  Widget _togglePublicado() {
    final scheme = Theme.of(context).colorScheme;
    final ativo = _publicado;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: (ativo ? Colors.green : Colors.orange).withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (ativo ? Colors.green : Colors.orange).withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            ativo ? Icons.public_rounded : Icons.edit_note_rounded,
            color: ativo ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ativo ? 'Publicada' : 'Rascunho',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  ativo
                      ? 'Visível para visitantes no catálogo'
                      : 'Não aparece para visitantes (oculta)',
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: ativo,
            onChanged: (v) => setState(() => _publicado = v),
          ),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _FotoPendente {
  final Uint8List bytes;
  final String name;
  _FotoPendente({required this.bytes, required this.name});
}
