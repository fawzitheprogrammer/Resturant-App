import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CardPaint extends CustomPainter{
  final Color color;
  const CardPaint({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = ui.Gradient.linear(
          Offset(0, size.height),
          Offset( size.width*0.4, size.height*0.6),
          [Colors.white10, Colors.white12])
      ..style = PaintingStyle.fill;

    Path path = Path()..moveTo(0, size.height*0.7)
      ..quadraticBezierTo(size.width*0.2, size.height*0.2, size.width*0.4, size.height*0.4)
      ..quadraticBezierTo(size.width*0.6, size.height*0.6, size.width*0.7, size.height*0.3)
      ..quadraticBezierTo(size.width*0.8, size.height*0.1, size.width*0.85, size.height*0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    Path path1 = Path()..moveTo(0, size.height)
      ..quadraticBezierTo(size.width*0.25, size.height*0.5, size.width*0.5, size.height*0.68)
      ..quadraticBezierTo(size.width*0.65, size.height*0.75, size.width*0.7, size.height*0.68)
      ..quadraticBezierTo(size.width*0.85, size.height*0.51, size.width*0.9, size.height*0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path1, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

}