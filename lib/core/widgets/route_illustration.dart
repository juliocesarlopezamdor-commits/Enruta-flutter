import 'package:flutter/material.dart';

class RouteIllustration extends StatelessWidget {
  const RouteIllustration({super.key});

  @override
  Widget build(BuildContext context) => const CustomPaint(
        painter: _RouteIllustrationPainter(),
        child: SizedBox.expand(),
      );
}

class _RouteIllustrationPainter extends CustomPainter {
  const _RouteIllustrationPainter();

  static const _navy = Color(0xFF0B2F52);
  static const _blue = Color(0xFF7FABC8);
  static const _gold = Color(0xFFE8B000);
  static const _green = Color(0xFF7AA887);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 260;
    canvas.save();
    canvas.scale(scale, size.height / 230);

    final paper = Paint()..color = const Color(0xFFE1ECF5);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 260, 230), paper);

    final road = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final route = Path()
      ..moveTo(28, 153)
      ..cubicTo(67, 151, 59, 112, 108, 116)
      ..cubicTo(149, 120, 146, 77, 188, 78)
      ..cubicTo(208, 79, 212, 56, 233, 48);
    canvas.drawPath(route, road);

    final lane = Paint()
      ..color = const Color(0xFFB7C6D2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(route, lane);

    _building(canvas, const Rect.fromLTWH(21, 42, 42, 36), const Color(0xFFB7C9D7));
    _building(canvas, const Rect.fromLTWH(74, 30, 30, 48), const Color(0xFF9BB5C8));
    _building(canvas, const Rect.fromLTWH(190, 128, 48, 37), const Color(0xFFD8C9A6));
    _building(canvas, const Rect.fromLTWH(31, 184, 39, 27), const Color(0xFFAAC3B1));

    final routePaint = Paint()
      ..color = _navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final routeLine = Path()
      ..moveTo(45, 154)
      ..cubicTo(77, 152, 74, 123, 108, 125)
      ..cubicTo(140, 127, 141, 91, 174, 91)
      ..cubicTo(191, 91, 198, 71, 216, 63);
    canvas.drawPath(routeLine, routePaint);

    _pin(canvas, const Offset(45, 149), _green);
    _pin(canvas, const Offset(108, 120), _blue);
    _pin(canvas, const Offset(174, 86), _blue);
    _pin(canvas, const Offset(216, 58), _gold);
    _van(canvas, const Offset(151, 131));

    canvas.restore();
  }

  void _building(Canvas canvas, Rect rect, Color color) {
    final fill = Paint()..color = color;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(5)), fill);
    final window = Paint()..color = Colors.white.withValues(alpha: .75);
    for (var x = rect.left + 8; x < rect.right - 4; x += 12) {
      for (var y = rect.top + 8; y < rect.bottom - 3; y += 12) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(x, y, 4, 5), const Radius.circular(1)),
          window,
        );
      }
    }
  }

  void _pin(Canvas canvas, Offset center, Color color) {
    final paint = Paint()..color = color;
    canvas.drawCircle(center, 8, paint);
    canvas.drawCircle(center, 2.5, Paint()..color = Colors.white);
  }

  void _van(Canvas canvas, Offset origin) {
    final body = Paint()..color = _navy;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(origin.dx, origin.dy, 43, 23),
        const Radius.circular(5),
      ),
      body,
    );
    final cab = Path()
      ..moveTo(origin.dx + 28, origin.dy)
      ..lineTo(origin.dx + 37, origin.dy)
      ..lineTo(origin.dx + 43, origin.dy + 8)
      ..lineTo(origin.dx + 43, origin.dy + 23)
      ..lineTo(origin.dx + 28, origin.dy + 23)
      ..close();
    canvas.drawPath(cab, Paint()..color = _blue);
    final wheels = Paint()..color = const Color(0xFF0F1E2B);
    canvas.drawCircle(Offset(origin.dx + 10, origin.dy + 23), 4, wheels);
    canvas.drawCircle(Offset(origin.dx + 34, origin.dy + 23), 4, wheels);
  }

  @override
  bool shouldRepaint(covariant _RouteIllustrationPainter oldDelegate) => false;
}
