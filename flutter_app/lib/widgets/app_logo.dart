import 'package:flutter/material.dart';
import 'dart:math' as math;

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const AppLogo({
    super.key,
    this.size = 100,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _LogoPainter(
              primaryColor: const Color(0xFFF97316),
              secondaryColor: const Color(0xFF1F2937),
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          Text(
            'Tashkent Table',
            style: TextStyle(
              fontSize: size * 0.24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  _LogoPainter({required this.primaryColor, required this.secondaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Draw Outer Decorative Ring (Traditional Pattern Style)
    final ringPaint = Paint()
      ..color = primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, ringPaint);

    // 2. Draw Octagonal Border (Common in Uzbek Architecture)
    final path = Path();
    for (int i = 0; i < 8; i++) {
      double angle = (i * 45) * math.pi / 180;
      double x = center.dx + radius * 0.85 * math.cos(angle);
      double y = center.dy + radius * 0.85 * math.sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = primaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.05
        ..strokeJoin = StrokeJoin.round,
    );

    // 3. Draw stylized Table/Plate
    canvas.drawCircle(
      center,
      radius * 0.5,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      center,
      radius * 0.5,
      Paint()
        ..color = primaryColor.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // 4. Draw "TT" Initials
    final tp = TextPainter(
      text: textSpan(size),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  TextSpan textSpan(Size size) {
    return TextSpan(
      text: 'TT',
      style: TextStyle(
        color: secondaryColor,
        fontWeight: FontWeight.w900,
        fontSize: size.width * 0.35,
        fontFamily: 'monospace',
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
