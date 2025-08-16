import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

/// A shape that creates star patterns with a configurable number of points.
///
/// [StarShape] generates geometric paths for star shapes by alternating between
/// outer points (full radius) and inner points (half radius) to create the
/// classic star appearance. The star is inscribed in a circle that fits within
/// the bounding rectangle.
///
/// Example usage:
/// ```dart
/// // Create a 5-pointed star
/// StarShape(noOfPoints: 5)
///
/// // Create an 8-pointed star
/// StarShape(noOfPoints: 8)
/// ```
class StarShape extends Shape {
  /// The number of points (outer vertices) for the star.
  ///
  /// Must be greater than 3 to form a valid star shape. Each point creates
  /// both an outer vertex and an inner vertex, so the total number of vertices
  /// will be [noOfPoints] * 2.
  final int noOfPoints;

  /// Creates a new [StarShape] with the specified number of points.
  ///
  /// The [noOfPoints] parameter must be greater than 3 to create a recognizable star shape.
  ///
  /// Throws an [AssertionError] if [noOfPoints] is 3 or less.
  StarShape({required this.noOfPoints}) : assert(noOfPoints > 3);

  @override
  Path build({Rect? rect, double? scale}) {
    return generatePath(rect: rect!);
  }

  Path generatePath({bool? useBezier, required Rect rect}) {
    final height = rect.height;
    final width = rect.width;

    final int vertices = noOfPoints * 2;
    final double alpha = (2 * pi) / vertices;
    final double radius = (height <= width ? height : width) / 2.0;
    final double centerX = width / 2;
    final double centerY = height / 2;

    final Path path = Path();
    for (int i = vertices + 1; i != 0; i--) {
      final double r = radius * (i % 2 + 1) / 2;
      final double omega = alpha * i;
      path.lineTo((r * sin(omega)) + centerX, (r * cos(omega)) + centerY);
    }
    path.close();
    return path;
  }
}
