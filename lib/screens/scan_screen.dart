import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../i18n/strings.dart';
import '../providers/locale_provider.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    formats: const [BarcodeFormat.qrCode],
  );
  bool _handled = false;
  String? _erro;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Extrai o slug de uma URL completa, fragmento ou texto simples.
  String? _extrairSlug(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return null;
    // 1) URL completa com /especie/<slug> ou /ficha/<id>
    final reg = RegExp(r'/(especie|ficha)/([a-z0-9-]+)',
        caseSensitive: false);
    final m = reg.firstMatch(t);
    if (m != null) return m.group(2);
    // 2) Apenas slug (letras, números, hífen)
    if (RegExp(r'^[a-z0-9-]+$', caseSensitive: false).hasMatch(t)) {
      return t;
    }
    return null;
  }

  void _aoDetectar(BarcodeCapture cap) {
    if (_handled) return;
    for (final b in cap.barcodes) {
      final raw = b.rawValue ?? '';
      final slug = _extrairSlug(raw);
      if (slug != null) {
        _handled = true;
        HapticFeedback.mediumImpact();
        _controller.stop();
        context.go('/especie/$slug');
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings(context.watch<LocaleProvider>().locale);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/'),
        ),
        title: Text(s.escanear,
            style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            tooltip: s.lanterna,
            icon: const Icon(Icons.flash_on_rounded),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            tooltip: s.alternarCamera,
            icon: const Icon(Icons.cameraswitch_rounded),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _aoDetectar,
            errorBuilder: (ctx, err, child) {
              _erro = err.errorDetails?.message ?? err.errorCode.name;
              return _CamErro(msg: _erro!, s: s);
            },
            fit: BoxFit.cover,
          ),
          _Overlay(instrucao: s.scanInstrucao),
        ],
      ),
    );
  }
}

class _Overlay extends StatelessWidget {
  final String instrucao;
  const _Overlay({required this.instrucao});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, c) {
        final lado = (c.maxWidth < c.maxHeight ? c.maxWidth : c.maxHeight) *
            0.65;
        return Stack(
          children: [
            // Máscara escura com recorte central
            IgnorePointer(
              child: CustomPaint(
                size: Size(c.maxWidth, c.maxHeight),
                painter: _MaskPainter(holeSize: lado),
              ),
            ),
            // Cantos do recorte
            Center(
              child: SizedBox(
                width: lado,
                height: lado,
                child: const _Cantos(),
              ),
            ),
            // Texto instrução
            Positioned(
              left: 24,
              right: 24,
              bottom: 60,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.qr_code_scanner_rounded,
                        color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        instrucao,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MaskPainter extends CustomPainter {
  final double holeSize;
  _MaskPainter({required this.holeSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.55);
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: holeSize,
      height: holeSize,
    );
    final outer = Path()..addRect(Offset.zero & size);
    final inner = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(22)));
    final result = Path.combine(PathOperation.difference, outer, inner);
    canvas.drawPath(result, paint);
  }

  @override
  bool shouldRepaint(covariant _MaskPainter old) =>
      old.holeSize != holeSize;
}

class _Cantos extends StatelessWidget {
  const _Cantos();

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;
    const w = 4.0;
    const len = 28.0;
    Widget canto(Alignment a) {
      final tl = a == Alignment.topLeft;
      final tr = a == Alignment.topRight;
      final bl = a == Alignment.bottomLeft;
      final br = a == Alignment.bottomRight;
      return Align(
        alignment: a,
        child: SizedBox(
          width: len,
          height: len,
          child: CustomPaint(
            painter: _CantoPainter(
              top: tl || tr,
              bottom: bl || br,
              left: tl || bl,
              right: tr || br,
              stroke: w,
              color: color,
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        canto(Alignment.topLeft),
        canto(Alignment.topRight),
        canto(Alignment.bottomLeft),
        canto(Alignment.bottomRight),
      ],
    );
  }
}

class _CantoPainter extends CustomPainter {
  final bool top, bottom, left, right;
  final double stroke;
  final Color color;
  _CantoPainter({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
    required this.stroke,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    if (top) {
      canvas.drawLine(
          Offset(left ? 0 : size.width, 0),
          Offset(left ? size.width * 0.6 : size.width * 0.4, 0),
          p);
    }
    if (bottom) {
      canvas.drawLine(
          Offset(left ? 0 : size.width, size.height),
          Offset(left ? size.width * 0.6 : size.width * 0.4, size.height),
          p);
    }
    if (left) {
      canvas.drawLine(
          Offset(0, top ? 0 : size.height),
          Offset(0, top ? size.height * 0.6 : size.height * 0.4),
          p);
    }
    if (right) {
      canvas.drawLine(
          Offset(size.width, top ? 0 : size.height),
          Offset(size.width, top ? size.height * 0.6 : size.height * 0.4),
          p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _CamErro extends StatelessWidget {
  final String msg;
  final Strings s;
  const _CamErro({required this.msg, required this.s});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.no_photography_outlined,
                color: Colors.white70, size: 56),
            const SizedBox(height: 14),
            Text(
              msg.toLowerCase().contains('denied') ||
                      msg.toLowerCase().contains('permission')
                  ? s.camPermissaoNegada
                  : s.camIndisponivel,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              msg,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
