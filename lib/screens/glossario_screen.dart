import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/glossario.dart';
import '../providers/locale_provider.dart';
import '../widgets/lang_switch.dart';

class GlossarioScreen extends StatefulWidget {
  const GlossarioScreen({super.key});

  @override
  State<GlossarioScreen> createState() => _GlossarioScreenState();
}

class _GlossarioScreenState extends State<GlossarioScreen> {
  String _busca = '';

  String _termo(TermoGlossario t, AppLocale loc) {
    switch (loc) {
      case AppLocale.pt:
        return t.termoPt;
      case AppLocale.en:
        return (t.termoEn?.isNotEmpty == true) ? t.termoEn! : t.termoPt;
      case AppLocale.es:
        return (t.termoEs?.isNotEmpty == true) ? t.termoEs! : t.termoPt;
    }
  }

  String _def(TermoGlossario t, AppLocale loc) {
    switch (loc) {
      case AppLocale.pt:
        return t.definicaoPt;
      case AppLocale.en:
        return t.definicaoEn;
      case AppLocale.es:
        return t.definicaoEs;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocaleProvider>().locale;
    final scheme = Theme.of(context).colorScheme;

    final titulo = loc == AppLocale.pt
        ? 'Glossário'
        : loc == AppLocale.en
            ? 'Glossary'
            : 'Glosario';
    final hintBusca = loc == AppLocale.pt
        ? 'Buscar termo...'
        : loc == AppLocale.en
            ? 'Search term...'
            : 'Buscar término...';
    final intro = loc == AppLocale.pt
        ? 'Termos que aparecem nas fichas das espécies, explicados em palavras simples.'
        : loc == AppLocale.en
            ? 'Terms that appear in species cards, explained in simple words.'
            : 'Términos que aparecen en las fichas de las especies, explicados en palabras simples.';

    final lista = [...kGlossario]
      ..sort((a, b) => _termo(a, loc)
          .toLowerCase()
          .compareTo(_termo(b, loc).toLowerCase()));
    final filtrada = _busca.trim().isEmpty
        ? lista
        : lista.where((t) {
            final b = _busca.toLowerCase();
            return _termo(t, loc).toLowerCase().contains(b) ||
                _def(t, loc).toLowerCase().contains(b);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/'),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Center(child: LangSwitch()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          Text(
            intro,
            style: TextStyle(
              fontSize: 14,
              color: scheme.onSurface.withOpacity(0.7),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (v) => setState(() => _busca = v),
            decoration: InputDecoration(
              hintText: hintBusca,
              prefixIcon: const Icon(Icons.search_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (filtrada.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  loc == AppLocale.pt
                      ? 'Nenhum termo encontrado.'
                      : loc == AppLocale.en
                          ? 'No term found.'
                          : 'No se encontró ningún término.',
                  style: TextStyle(
                    color: scheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ...filtrada.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: scheme.onSurface.withOpacity(0.06),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _termo(t, loc),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: scheme.primary,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _def(t, loc),
                        style: TextStyle(
                          fontSize: 14,
                          color: scheme.onSurface,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
