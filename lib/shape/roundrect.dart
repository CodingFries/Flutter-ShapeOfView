import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:vector_math/vector_math.dart';

class RoundRectShape extends Shape with BorderShape {
  final BorderRadius borderRadius;

  final Color borderColor;
  final double borderWidth;

  final Paint borderPaint = Paint();

  RoundRectShape({
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.borderWidth = 0.0,
    this.borderColor = const Color(0xffffffff),
  }) {
    this.borderPaint.isAntiAlias = true;
    this.borderPaint.style = PaintingStyle.stroke;
  }

  @override
  Path build({Rect? rect, double? scale}) {
    return generatePath(useBezier: false, rect: rect!);
  }

  Path generatePath({required bool useBezier, required Rect rect}) {
    final Path path = Path();

    final double left = rect.left;
    final double top = rect.top;
    final double bottom = rect.bottom;
    final double right = rect.right;

    final double maxSize = min(rect.width / 2.0, rect.height / 2.0);

    double topLeftRadius = borderRadius.topLeft.x.abs();
    double topRightRadius = borderRadius.topRight.x.abs();
    double bottomLeftRadius = borderRadius.bottomLeft.x.abs();
    double bottomRightRadius = borderRadius.bottomRight.x.abs();

    if (topLeftRadius > maxSize) {
      topLeftRadius = maxSize;
    }
    if (topRightRadius > maxSize) {
      topRightRadius = maxSize;
    }
    if (bottomLeftRadius > maxSize) {
      bottomLeftRadius = maxSize;
    }
    if (bottomRightRadius > maxSize) {
      bottomRightRadius = maxSize;
    }

    path.moveTo(left + topLeftRadius, top);
    path.lineTo(right - topRightRadius, top);

    //float left, float top, float right, float bottom, float startAngle, float sweepAngle, boolean forceMoveTo
    if (useBezier) {
      path.quadraticBezierTo(right, top, right, top + topRightRadius);
    } else {
      final double arc = topRightRadius > 0 ? 90 : -270;
      path.arcTo(
          Rect.fromLTRB(right - topRightRadius * 2.0, top, right,
              top + topRightRadius * 2.0),
          radians(-90),
          radians(arc),
          false);
    }
    path.lineTo(right, bottom - bottomRightRadius);
    if (useBezier) {
      path.quadraticBezierTo(right, bottom, right - bottomRightRadius, bottom);
    } else {
      final double arc = bottomRightRadius > 0 ? 90 : -270;
      path.arcTo(
          Rect.fromLTRB(right - bottomRightRadius * 2.0,
              bottom - bottomRightRadius * 2.0, right, bottom),
          0,
          radians(arc),
          false);
    }
    path.lineTo(left + bottomLeftRadius, bottom);
    if (useBezier) {
      path.quadraticBezierTo(left, bottom, left, bottom - bottomLeftRadius);
    } else {
      final double arc = bottomLeftRadius > 0 ? 90 : -270;
      path.arcTo(
          Rect.fromLTRB(left, bottom - bottomLeftRadius * 2.0,
              left + bottomLeftRadius * 2.0, bottom),
          radians(90),
          radians(arc),
          false);
    }
    path.lineTo(left, top + topLeftRadius);
    if (useBezier) {
      path.quadraticBezierTo(left, top, left + topLeftRadius, top);
    } else {
      final double arc = topLeftRadius > 0 ? 90 : -270;
      path.arcTo(
          Rect.fromLTRB(
              left, top, left + topLeftRadius * 2.0, top + topLeftRadius * 2.0),
          radians(180),
          radians(arc),
          false);
    }
    path.close();

    return path;
  }

  @override
  void drawBorder(Canvas canvas, Rect rect) {
    if (this.borderWidth > 0) {
      borderPaint.strokeWidth = borderWidth;
      borderPaint.color = borderColor;
      canvas.drawPath(generatePath(useBezier: false, rect: rect), borderPaint);
    }
  }
}
