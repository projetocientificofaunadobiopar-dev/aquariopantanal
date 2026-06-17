import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../i18n/strings.dart';
import '../providers/locale_provider.dart';

/// Tela modal que recebe bytes de imagem e retorna bytes cropados em 3:4.
///
/// Aspect ratio escolhido: 3:4 (portrait) — corresponde ao formato dos
/// cards da home (0.72 ≈ 0.75) e mantém o animal centralizado no header
/// da ficha (que é horizontal e vai cortar levemente em cima/baixo).
class PhotoCropperPage extends StatefulWidget {
  final Uint8List bytes;
  const PhotoCropperPage({super.key, required this.bytes});

  /// Abre como rota modal e retorna os bytes cropados (ou null se cancelar).
  static Future<Uint8List?> abrir(
      BuildContext context, Uint8List bytes) {
    return Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => PhotoCropperPage(bytes: bytes),
      ),
    );
  }

  @override
  State<PhotoCropperPage> createState() => _PhotoCropperPageState();
}

class _PhotoCropperPageState extends State<PhotoCropperPage> {
  final _controller = CropController();
  bool _processing = false;

  @override
  Widget build(BuildContext context) {
    final s = Strings(context.watch<LocaleProvider>().locale);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(s.ajustarFoto),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Crop(
              image: widget.bytes,
              controller: _controller,
              aspectRatio: 3 / 4,
              baseColor: Colors.black,
              maskColor: Colors.black.withOpacity(0.65),
              cornerDotBuilder: (size, edge) => DotControl(
                color: scheme.primary,
              ),
              radius: 12,
              interactive: true,
              onCropped: (result) {
                if (!mounted) return;
                if (result is CropSuccess) {
                  Navigator.of(context).pop(result.croppedImage);
                } else {
                  setState(() => _processing = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(s.erro)),
                  );
                }
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                children: [
                  Text(
                    s.cropDica,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _processing
                          ? null
                          : () {
                              setState(() => _processing = true);
                              _controller.crop();
                            },
                      icon: _processing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white),
                            )
                          : const Icon(Icons.check_rounded),
                      label: Text(s.confirmar,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
