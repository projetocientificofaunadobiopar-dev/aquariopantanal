import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/avaliacao_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/visitas_provider.dart';
import '../services/supabase_service.dart';

const _emojis = ['😞', '🙁', '😐', '🙂', '😍'];

/// Modal de avaliação rápida. Aparece automaticamente após o visitante
/// abrir N espécies, controlado por [AvaliacaoProvider].
class AvaliacaoModal extends StatefulWidget {
  const AvaliacaoModal({super.key});

  @override
  State<AvaliacaoModal> createState() => _AvaliacaoModalState();

  /// Mostra o modal automaticamente se o visitante já viu >= [minVisitas]
  /// espécies e ainda não avaliou nem dispensou.
  static Future<void> talvezMostrar(
    BuildContext context, {
    int minVisitas = 3,
  }) async {
    final av = context.read<AvaliacaoProvider>();
    final vis = context.read<VisitasProvider>();
    if (!av.devePerguntar) return;
    if (vis.total < minVisitas) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const Padding(
        padding: EdgeInsets.only(top: 8),
        child: AvaliacaoModal(),
      ),
    );
  }
}

class _AvaliacaoModalState extends State<AvaliacaoModal> {
  int? _nota;
  final _comentario = TextEditingController();
  bool _enviando = false;
  String? _erro;

  @override
  void dispose() {
    _comentario.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (_nota == null) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _enviando = true;
      _erro = null;
    });
    try {
      final loc = context.read<LocaleProvider>().locale;
      final vis = context.read<VisitasProvider>().total;
      await SupabaseService().enviarAvaliacao(
        nota: _nota!,
        comentario: _comentario.text,
        idioma: loc.name,
        visitadas: vis,
      );
      if (!mounted) return;
      await context.read<AvaliacaoProvider>().marcarEnviada();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _enviando = false;
          _erro = e.toString();
        });
      }
    }
  }

  Future<void> _dispensar() async {
    await context.read<AvaliacaoProvider>().dispensar();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocaleProvider>().locale;
    final scheme = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context);

    final titulo = loc == AppLocale.pt
        ? 'Que tal a visita?'
        : loc == AppLocale.en
            ? 'How was your visit?'
            : '¿Qué tal la visita?';
    final subtitulo = loc == AppLocale.pt
        ? 'Sua opinião ajuda a melhorar a experiência no Bioparque.'
        : loc == AppLocale.en
            ? 'Your feedback helps us improve the Biopark experience.'
            : 'Tu opinión ayuda a mejorar la experiencia en el Biopark.';
    final hintComent = loc == AppLocale.pt
        ? 'O que você mais gostou? (opcional)'
        : loc == AppLocale.en
            ? 'What did you like most? (optional)'
            : '¿Qué te gustó más? (opcional)';
    final agora = loc == AppLocale.pt
        ? 'Não, obrigado'
        : loc == AppLocale.en
            ? 'No thanks'
            : 'No, gracias';
    final enviar = loc == AppLocale.pt
        ? 'Enviar'
        : loc == AppLocale.en
            ? 'Send'
            : 'Enviar';

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: media.viewInsets.bottom + media.padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.onSurface.withOpacity(0.18),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitulo,
            style: TextStyle(
              fontSize: 14,
              color: scheme.onSurface.withOpacity(0.7),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_emojis.length, (i) {
              final nota = i + 1;
              final ativo = _nota == nota;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _nota = nota);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ativo
                        ? scheme.primary.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: ativo
                          ? scheme.primary
                          : scheme.onSurface.withOpacity(0.1),
                      width: ativo ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    _emojis[i],
                    style: TextStyle(fontSize: ativo ? 36 : 30),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _comentario,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: hintComent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          if (_erro != null) ...[
            const SizedBox(height: 8),
            Text(
              _erro!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _enviando ? null : _dispensar,
                  child: Text(agora),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: (_nota == null || _enviando) ? null : _enviar,
                  child: _enviando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(enviar),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
