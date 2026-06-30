import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImagemComprimida {
  final Uint8List bytes;
  final String filename;
  final String contentType;
  ImagemComprimida({
    required this.bytes,
    required this.filename,
    required this.contentType,
  });
}

/// Decodifica, redimensiona pra `maxWidth` (se maior) e re-encoda como JPEG
/// de qualidade `quality`. Ideal pra upload — diminui o tamanho típico em
/// 70–90% comparado ao PNG original do cropper. Fallback: devolve o
/// original se a decodificação falhar.
Future<ImagemComprimida> comprimirParaUpload(
  Uint8List bytes,
  String filename, {
  int maxWidth = 1600,
  int quality = 85,
}) async {
  final original = img.decodeImage(bytes);
  if (original == null) {
    return ImagemComprimida(
      bytes: bytes,
      filename: filename,
      contentType: 'image/jpeg',
    );
  }
  final resized = original.width > maxWidth
      ? img.copyResize(original, width: maxWidth)
      : original;
  final jpg = img.encodeJpg(resized, quality: quality);
  final base = filename.replaceAll(RegExp(r'\.[^.]+$'), '');
  return ImagemComprimida(
    bytes: Uint8List.fromList(jpg),
    filename: '$base.jpg',
    contentType: 'image/jpeg',
  );
}
