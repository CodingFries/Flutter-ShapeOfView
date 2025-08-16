import 'package:flutter/material.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

/// A shape that creates triangles with customizable vertex positions.
///
/// [TriangleShape] generates geometric paths for triangles where the position
/// of each vertex can be controlled using percentage values. This allows for
/// creating various triangle types including right triangles, isosceles triangles,
/// and asymmetric triangles.
///
/// The triangle is defined by three vertices:
/// - Left vertex: positioned at (0, [percentLeft] * height)
/// - Bottom vertex: positioned at ([percentBottom] * width, height)
/// - Right vertex: positioned at (width, [percentRight] * height)
///
/// Example usage:
/// ```dart
/// // Create a centered isosceles triangle
/// TriangleShape(percentBottom: 0.5, percentLeft: 0, percentRight: 0)
///
/// // Create a right triangle
/// TriangleShape(percentBottom: 0, percentLeft: 0, percentRight: 0)
///
/// // Create an asymmetric triangle
/// TriangleShape(percentBottom: 0.7, percentLeft: 0.2, percentRight: 0.1)
/// ```
class TriangleShape extends Shape {
  /// The horizontal position of the bottom vertex as a percentage of the rectangle width.
  ///
  /// Value of 0.0 places the vertex at the left edge, 0.5 at the center,
  /// and 1.0 at the right edge. Defaults to 0.5 (center).
  final double percentBottom;

  /// The vertical position of the left vertex as a percentage of the rectangle height.
  ///
  /// Value of 0.0 places the vertex at the top edge, 0.5 at the center,
  /// and 1.0 at the bottom edge. Defaults to 0.0 (top edge).
  final double percentLeft;

  /// The vertical position of the right vertex as a percentage of the rectangle height.
  ///
  /// Value of 0.0 places the vertex at the top edge, 0.5 at the center,
  /// and 1.0 at the bottom edge. Defaults to 0.0 (top edge).
  final double percentRight;

  /// Creates a new [TriangleShape] with customizable vertex positions.
  ///
  /// [percentBottom] - Horizontal position of bottom vertex (0.0 to 1.0). Defaults to 0.5.
  /// [percentLeft] - Vertical position of left vertex (0.0 to 1.0). Defaults to 0.0.
  /// [percentRight] - Vertical position of right vertex (0.0 to 1.0). Defaults to 0.0.
  ///
  /// All percentage values should be between 0.0 and 1.0 for best results.
  TriangleShape({
    this.percentBottom = 0.5,
    this.percentLeft = 0,
    this.percentRight = 0,
  });

  @override
  Path build({Rect? rect, double? scale}) {
    return generatePath(rect: rect!);
  }

  Path generatePath({bool? useBezier, required Rect rect}) {
    final width = rect.width;
    final height = rect.height;
    return Path()
      ..moveTo(0, percentLeft * height)
      ..lineTo(percentBottom * width, height)
      ..lineTo(width, percentRight * height)
      ..close();
  }
}
