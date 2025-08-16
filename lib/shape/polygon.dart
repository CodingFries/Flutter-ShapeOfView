import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

/// A shape that creates regular polygons with a configurable number of sides.
///
/// [PolygonShape] generates geometric paths for regular polygons (shapes with
/// equal sides and angles) such as triangles, squares, pentagons, hexagons, etc.
/// The polygon is inscribed in a circle that fits within the bounding rectangle.
///
/// Example usage:
/// ```dart
/// // Create a pentagon
/// PolygonShape(numberOfSides: 5)
///
/// // Create a hexagon
/// PolygonShape(numberOfSides: 6)
/// ```
class PolygonShape extends Shape {
  /// The number of sides for the polygon.
  ///
  /// Must be at least 3 to form a valid polygon. Defaults to 5 (pentagon).
  final int numberOfSides;

  /// Creates a new [PolygonShape] with the specified number of sides.
  ///
  /// The [numberOfSides] parameter must be at least 3. Defaults to 5 if not specified.
  ///
  /// Throws an [AssertionError] if [numberOfSides] is less than 3.
  PolygonShape({this.numberOfSides = 5}) : assert(numberOfSides >= 3);

  @override
  Path build({Rect? rect, double? scale}) {
    return generatePath(rect: rect!);
  }

  Path generatePath({bool? useBezier, required Rect rect}) {
    final height = rect.height;
    final width = rect.width;

    final double section = (2.0 * pi / numberOfSides);
    final double polygonSize = min(width, height);
    final double radius = polygonSize / 2;
    final double centerX = width / 2;
    final double centerY = height / 2;

    final Path polygonPath = new Path();
    polygonPath.moveTo(
      (centerX + radius * cos(0)),
      (centerY + radius * sin(0)),
    );

    for (int i = 1; i < numberOfSides; i++) {
      polygonPath.lineTo(
        (centerX + radius * cos(section * i)),
        (centerY + radius * sin(section * i)),
      );
    }

    polygonPath.close();
    return polygonPath;
  }
}
