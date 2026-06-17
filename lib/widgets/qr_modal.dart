import 'dart:async';
import 'dart:js_interop';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web/web.dart' as web;

import '../i18n/strings.dart';
import '../models/especie.dart';
import '../providers/locale_provider.dart';

class QrModal extends StatelessWidget {
  final Especie especie;
  const QrModal({super.key, required this.especie});

  static Future<void> abrir(BuildContext context, Especie especie) {
    return showDialog<void>(
      context: context,
      builder: (_) => QrModal(especie: especie),
    );
  }

  String _url() {
    final origin = web.window.location.origin;
    final slug = especie.slug ?? especie.id;
    return '$origin/#/especie/$slug';
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings(context.watch<LocaleProvider>().locale);
    final url = _url();
    final repaintKey = GlobalKey();

    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s.qrCode,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                especie.nomePopularPt,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 20),
              RepaintBoundary(
                key: repaintKey,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: QrImageView(
                    data: url,
                    version: QrVersions.auto,
                    size: 240,
                    backgroundColor: Colors.white,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Color(0xFF0F1B1A),
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Color(0xFF0F1B1A),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.04),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  url,
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: url));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(s.linkCopiado),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.link_rounded, size: 18),
                      label: Text(s.copiarLink),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _baixar(
                          repaintKey, especie.slug ?? especie.id),
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: Text(s.baixarQr),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(s.cancelar),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _baixar(GlobalKey key, String filename) async {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;
    final bytes = byteData.buffer.asUint8List();
    _downloadBytes(bytes, 'qr-$filename.png');
  }

  void _downloadBytes(Uint8List bytes, String filename) {
    final jsArr = bytes.toJS;
    final blob = web.Blob([jsArr].toJS,
        web.BlobPropertyBag(type: 'image/png'));
    final url = web.URL.createObjectURL(blob);
    final a = web.HTMLAnchorElement()
      ..href = url
      ..download = filename;
    a.click();
    Future<void>.delayed(const Duration(seconds: 1), () {
      web.URL.revokeObjectURL(url);
    });
  }
}
