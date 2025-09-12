import 'dart:ui';
import 'package:flutter/material.dart';

class InnerShadowCard extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const InnerShadowCard({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = CustomPaint(
      painter: _InnerShadowPainter(
        borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(20)),
        backgroundColor: backgroundColor ?? Colors.white.withOpacity(0.28),
      ),
      child: Container(
        width: width,
        height: height,
        padding: padding,
        child: child,
      ),
    );

    if (onTap != null) {
      cardContent = GestureDetector(
        onTap: onTap,
        child: cardContent,
      );
    }

    if (margin != null) {
      cardContent = Container(
        margin: margin,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

class _InnerShadowPainter extends CustomPainter {
  final BorderRadius borderRadius;
  final Color backgroundColor;

  _InnerShadowPainter({
    required this.borderRadius,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, borderRadius.topLeft);

    // Draw background
    final Paint backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawRRect(rrect, backgroundPaint);

    // Clip to rounded rectangle so shadow stays inside
    canvas.save();
    canvas.clipRRect(rrect);

    // Draw shadows (inverted using blend mode)
    _drawInnerShadow(
      canvas,
      rrect,
      offset: const Offset(3, 3),
      blur: 4,
      color: Colors.white.withOpacity(0.35),
    );

    _drawInnerShadow(
      canvas,
      rrect,
      offset: const Offset(-3, -6),
      blur: 3,
      color: Colors.white.withOpacity(0.30),
    );

    _drawInnerShadow(
      canvas,
      rrect,
      offset: const Offset(0, 0),
      blur: 20,
      color: Colors.white.withOpacity(0.40),
    );

    canvas.restore();
  }

  void _drawInnerShadow(Canvas canvas, RRect rrect,
      {required Offset offset,
      required double blur,
      required Color color}) {
    final Paint shadowPaint = Paint()
      ..blendMode = BlendMode.srcATop
      ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
      ..color = color;

    // Shift rect by offset
    final shifted = rrect.shift(offset);

    // Draw shifted shape filled with shadow color
    canvas.drawRRect(shifted, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
